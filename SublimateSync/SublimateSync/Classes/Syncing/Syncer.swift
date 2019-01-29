//
//  Syncer.swift
//  SublimateSync
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import Foundation
import RxSwift
import RealmSwift
import PromiseKit
import RxRealm
import Reachability
import RxReachability
import RxCocoa

public protocol SyncerProtocol {
    var isSyncing: ReadOnlyVariable<Bool> { get }
    var lastError: ReadOnlyVariable<Error?> { get }

    func activate()
    func scheduleSyncronization()
    func startRefreshTimer(period : RxTimeInterval)
    func stopRefreshTimer()
}

public class Syncer <T : Syncable> : SyncerProtocol {
    let realmConfiguration : Realm.Configuration

    var isReachable: Observable<Bool> {
        return reachability.rx.isReachable.startWith(reachability.connection != .none)
    }

    private let networkClient : NetworkClient<T>
    private let reachability : Reachability

    private let syncQueue : DispatchQueue
    private let syncScheduler : SerialDispatchQueueScheduler

    private var disposeBag = DisposeBag()

    private let isSyncingInternal = Variable<Bool>(false)
    private let hasPendingChanges = Variable<Bool>(false)
    private let isSyncScheduled = Variable<Bool>(false)
    private let lastSyncError: Variable<Error?> = Variable(nil)

    private func subscribePendingChanges() {
        if let realm = try? Realm(configuration: realmConfiguration) {
            let pending = realm.objects(T.self).filter(T.pendingObjectsPredicate())
            Observable.changeset(from: pending, synchronousStart: true).asObservable().map { (result, changes) -> Bool in
                return result.count > 0
                }.subscribe(onNext: { [weak self] hasItems in
                    self?.hasPendingChanges.value = hasItems
                }).disposed(by: disposeBag)
        }
    }

    public init(networkClient : NetworkClient<T>, realmConfiguration : Realm.Configuration, reachability : Reachability) {
        self.networkClient = networkClient
        self.realmConfiguration = realmConfiguration
        self.reachability = reachability
        self.syncQueue = DispatchQueue.global(qos: .userInitiated)
        self.syncScheduler = SerialDispatchQueueScheduler(queue: syncQueue, internalSerialQueueName: "sublimate.syncer")
    }

    private func runSynchronizationFlow() {
        isSyncingInternal.value = true
        Logger.log("Syncer for \(T.self) started")
        firstly { () -> Promise<Void> in
            upstreamChanges()
            }.then { _ -> Promise<Void> in
                self.downstreamChanges()
            }.done { _ in
                Logger.log("Syncer for \(T.self) completed successfully")
                self.lastSyncError.value = nil
            }.catch { (error) in
                Logger.error("Syncer for \(T.self) completed with error \(error)")
                self.lastSyncError.value = error
            }.finally {
                self.isSyncingInternal.value = false
                self.isSyncScheduled.value = false
        }
    }

    private func upstreamChanges() -> Promise<Void> {
        guard let realm = try? Realm(configuration: realmConfiguration) else {
            return Promise(error: NSError(domain: "sublimate.syncer", code: 900, userInfo: ["reason" : "Unable to instantiate realm"]))
        }
        debug("upstreamChanges for \(T.self) started")
        let pending = realm.objects(T.self).filter(T.pendingObjectsPredicate())
        let promises : [Promise<Void>] = pending.map { (item) -> Promise<Void> in
            self.sync(item: item)
        }
        return when(resolved: promises).asVoid()
    }

    private func sync(item : T) -> Promise<Void> {
        debug("Syncing upstream object id \(item.syncIdentifier ?? "*local*") for operation \(item.syncOperation)")
        let clientLastUpdated = item.clientLastUpdated
        guard let keyField = T.primaryKey(), let itemKey = item[keyField] else {
            Logger.error("Unable to sync object without a key")
            return Promise(error: NSError(domain: "sublimate.syncer", code: 900, userInfo: ["reason" : "Unable to sync object without a key"]))
        }

        return networkClient.syncOrDelete(item: item)
            .tap({ result in
                if  case Result.rejected(_) = result,
                    let realm = try? Realm(configuration: self.realmConfiguration),
                    var object = realm.object(ofType: T.self, forPrimaryKey: itemKey)
                {
                    try? realm.write
                    {
                        object.isInErrorState = true
                    }
                }
            })
            .then(on: syncQueue) { (dto) -> Promise<Void> in
                do {
                    let realm = try Realm(configuration: self.realmConfiguration)
                    guard var object = realm.object(ofType: T.self, forPrimaryKey: itemKey) else {
                        Logger.error("An object has been deleted from Realm while being synchronized")
                        return Promise(error: NSError(domain: "sublimate.syncer", code: 900, userInfo: ["reason" : "Object not found in Realm"]))
                    }
                    let syncOp = object.syncOperation
                    let syncIdentifier = object.syncIdentifier

                    switch syncOp {
                    case .create, .update:
                        if let dto = dto, clientLastUpdated == object.clientLastUpdated {
                            try realm.write {
                                dto.update(object: object)
                                object.syncOperation = .none
                                realm.add(object, update: true)
                            }
                            self.debug("Object id \(syncIdentifier ?? "*local*") was successfully synced with operation \(syncOp)")
                        }
                        else {
                            self.debug("Object id \(syncIdentifier ?? "*local*") was mutated during synchronization and is not clean")
                        }
                        return Promise.value(())
                    case .delete:
                        let realm = try Realm(configuration: self.realmConfiguration)
                        try realm.write {
                            realm.delete(object)
                        }
                        self.debug("Object id \(syncIdentifier ?? "*local*") was successfully deleted")
                        return Promise.value(())
                    default:
                        Logger.error("An object with inappropriate syncOperation has been fetched from Realm for synchronization")
                        return Promise(error: NSError(domain: "sublimate.syncer", code: 900, userInfo: ["reason" : "Object has inappropriate syncOperation"]))
                    }
                }
                catch let error {
                    Logger.error("Error while syncing: \(error.localizedDescription)")
                    return Promise(error: error)
                }
        }
    }

    private func downstreamChanges() -> Promise<Void> {
        debug("downstreamChanges for \(T.self) started")
        let configuration = self.realmConfiguration
        return networkClient.fetchAll().then(on: syncQueue) { (dtos) -> Promise<Void> in
            self.debug("downstreamChanges for \(T.self) received \(dtos.count) dtos")
            do {
                let realm = try Realm(configuration: configuration)
                var toBeRemoved = Set(realm.objects(T.self).filter(T.syncableObjectsPredicate(withSyncingOptions: nil)))
                try realm.write {
                    for dto in dtos {
                        guard let syncIdentifier = dto.syncIdentifier() else {
                            // The dto was malformed and is missing identifier
                            // We skip the item (GP TODO: maybe add logging)
                            return
                        }
                        if let item = realm.object(ofType: T.self, forSynchronizationId:syncIdentifier) {
                            toBeRemoved.remove(item)
                            if item.syncOperation == .none {
                                dto.update(object: item)
                                realm.add(item, update: true)
                            }
                        } else {
                            Logger.log("adding new \(T.self)")
                            let item = T()
                            dto.update(object: item)
                            realm.add(item)
                        }
                    }
                    toBeRemoved = toBeRemoved.filter( { $0.syncOperation == .none || $0.syncOperation == .delete || $0.syncOperation == .update } )
                    realm.delete(toBeRemoved)
                }
                return Promise.value(())
            } catch let error {
                Logger.error("Error while syncing: \(error.localizedDescription)")
                return Promise(error: error)
            }
        }
    }

    var verboseOutput : Bool = false
    private func debug(_ string : String) {
        if verboseOutput {
            Logger.log(string)
        }
    }
    
    private func subscribeSynchronization() {
        // GP TODO: We need an exponential backoff when the synchronization is failing
        Observable
            .combineLatest(
                hasPendingChanges.asObservable(),
                isSyncScheduled.asObservable(),
                isReachable,
                isSyncingInternal.asObservable())
            .map { (hasPendingChanges, isSyncScheduled, isReachable, isSyncingInternal) -> Bool in
                return !isSyncingInternal && isReachable && (hasPendingChanges || isSyncScheduled)
            }
            .filter { (shouldSync) -> Bool in
                return shouldSync
            }
            .throttle(3, scheduler: syncScheduler).observeOn(syncScheduler).subscribe(onNext: { [weak self] (_) in
                self?.runSynchronizationFlow()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Public
    public var isSyncing: ReadOnlyVariable<Bool> {
        get {
            return isSyncingInternal.asReadOnly()
        }
    }

    public var lastError: ReadOnlyVariable<Error?> {
        get {
            return lastSyncError.asReadOnly()
        }
    }

    public func activate() {
        disposeBag = DisposeBag()
        if T.pendingObjectsPredicate() != NSPredicate(value: false) {
            subscribePendingChanges()
        }
        subscribeSynchronization()
    }

    public func scheduleSyncronization() {
        isSyncScheduled.value = true
    }

    private var timerDisposeBag : DisposeBag?
    public func startRefreshTimer(period : RxTimeInterval = 30) {
        Logger.log("Refresh timer for \(self) has been started")
        timerDisposeBag = DisposeBag()
        if let timerDisposeBag = timerDisposeBag  {
            Observable<Int64>
                .timer(period, period: period, scheduler: MainScheduler.instance).subscribe { [weak self] _ in
                    self?.scheduleSyncronization()
                }
                .disposed(by: timerDisposeBag)
        }
    }

    public func stopRefreshTimer() {
        Logger.log("Refresh timer for \(self) has been stopped")
        timerDisposeBag = nil
    }
}

extension Realm {
    public func object<T: Syncable>(ofType type: T.Type, forSynchronizationId syncId: String) -> T? {
        return self.objects(T.self).filter( { $0.syncIdentifier == syncId } ).first
    }
}
