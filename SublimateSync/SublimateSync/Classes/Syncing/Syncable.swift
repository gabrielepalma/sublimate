//
//  Syncable.swift
//  SublimateClient
//
//  Created by i335287 on 07/11/2018.
//  Copyright © 2018 Gabriele. All rights reserved.
//

import Foundation
import RealmSwift
import PromiseKit

public enum SyncOperation : String {
    case none = "NONE"
    case create = "CREATE"
    case update = "UPDATE"
    case delete = "DELETE"
}

open class SyncableDTO<T> where T : Syncable{
    public init() {
    }

    public init(from object: T) {
    }

    open func update(object : T) {
    }

    open func syncIdentifier() -> String? {
        return nil
    }
}

open class NetworkClient<T>  where T : Syncable {
    public init() {
    }
    
    open func fetchAll(withSyncingOptions options : NSDictionary? = nil) -> Promise<[SyncableDTO<T>]> {
        return Promise(error: NSError(domain: "sublimate.networkclient", code: 900, userInfo: ["reason" : "Unsupported operation"]))
    }

    open func syncOne(item : T) -> Promise<SyncableDTO<T>> {
                return Promise(error: NSError(domain: "sublimate.networkclient", code: 900, userInfo: ["reason" : "Unsupported operation"]))
    }

    open func delete(item : T) -> Promise<Void> {
                return Promise(error: NSError(domain: "sublimate.networkclient", code: 900, userInfo: ["reason" : "Unsupported operation"]))
    }
}

extension NetworkClient {
    func syncOrDelete(item: T) -> Promise<SyncableDTO<T>?> {
        if item.syncOperation == .delete {
            return self.delete(item: item).map({ void -> SyncableDTO<T>? in
                return nil
            })
        }
        else if item.syncOperation == .update || item.syncOperation == .create {
            return self.syncOne(item: item).map({ res -> SyncableDTO<T>? in
                return res
            })
        }
        else {
            return Promise<SyncableDTO<T>?>(resolver: { r in
                r.fulfill(nil)
            })
        }
    }
}

public protocol Syncable where Self : Object {
    var syncIdentifier : String? { get }
    var syncOperation : SyncOperation { get set }
    var clientLastUpdated : TimeInterval { get set }

    static func pendingObjectsPredicate() -> NSPredicate
    static func syncableObjectsPredicate(withSyncingOptions options : NSDictionary?) -> NSPredicate
}

public protocol SublimatePresentable where Self : Object {
    var title : String? { get }
    var thumbnail : Promise<UIImage?> { get }
}
