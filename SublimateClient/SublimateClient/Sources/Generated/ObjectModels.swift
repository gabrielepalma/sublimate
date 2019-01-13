// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import RealmSwift
import SublimateSync

// MARK: - DemoAlpha Realm object
final class DemoAlphaObject: Object, Syncable {
    override public class func ignoredProperties() -> [String] {
        return ["syncIdentifier", "syncOperation"]
    }

    override public static func primaryKey() -> String? {
        return "localId"
    }

    override static func indexedProperties() -> [String] {
        return ["remoteId"]
    }

    var syncIdentifier: String? {
        return remoteId
    }

    var syncOperation: SyncOperation {
        get {
            return SyncOperation(rawValue: realmSyncOperation) ?? .none
        }
        set {
            realmSyncOperation = newValue.rawValue
        }
    }

    static func pendingObjectsPredicate() -> NSPredicate {
        return NSPredicate(format: "realmSyncOperation in %@", [SyncOperation.create.rawValue, SyncOperation.update.rawValue, SyncOperation.delete.rawValue])
    }

    static func syncableObjectsPredicate(withSyncingOptions options: NSDictionary?) -> NSPredicate {
        return NSPredicate(value: true)
    }

    @objc dynamic var clientCreated: TimeInterval = Date().timeIntervalSince1970
    @objc dynamic var clientLastUpdated: TimeInterval = Date().timeIntervalSince1970
    @objc dynamic var remoteId: String? = nil
    @objc dynamic var localId: String = UUID().uuidString
    @objc private dynamic var realmSyncOperation : String = SyncOperation.none.rawValue

    @objc dynamic var text: String = String.sublimateDefault()
    @objc dynamic var count: Int = Int.sublimateDefault()

    convenience init(dto: SyncableDTO<DemoAlphaObject>) {
        self.init()
        remoteId = dto.syncIdentifier()
        dto.update(object: self)
    }

    var clientCreatedDate : Date {
        return Date(timeIntervalSince1970: clientCreated)
    }

    var clientLastUpdatedDate : Date {
        return Date(timeIntervalSince1970: clientLastUpdated)
    }
}

// MARK: - DemoBeta Realm object
final class DemoBetaObject: Object, Syncable {
    override public class func ignoredProperties() -> [String] {
        return ["syncIdentifier", "syncOperation"]
    }

    override public static func primaryKey() -> String? {
        return "localId"
    }

    override static func indexedProperties() -> [String] {
        return ["remoteId"]
    }

    var syncIdentifier: String? {
        return remoteId
    }

    var syncOperation: SyncOperation {
        get {
            return SyncOperation(rawValue: realmSyncOperation) ?? .none
        }
        set {
            realmSyncOperation = newValue.rawValue
        }
    }

    static func pendingObjectsPredicate() -> NSPredicate {
        return NSPredicate(format: "realmSyncOperation in %@", [SyncOperation.create.rawValue, SyncOperation.update.rawValue, SyncOperation.delete.rawValue])
    }

    static func syncableObjectsPredicate(withSyncingOptions options: NSDictionary?) -> NSPredicate {
        return NSPredicate(value: true)
    }

    @objc dynamic var clientCreated: TimeInterval = Date().timeIntervalSince1970
    @objc dynamic var clientLastUpdated: TimeInterval = Date().timeIntervalSince1970
    @objc dynamic var remoteId: String? = nil
    @objc dynamic var localId: String = UUID().uuidString
    @objc private dynamic var realmSyncOperation : String = SyncOperation.none.rawValue

    @objc dynamic var name: String = String.sublimateDefault()
    @objc dynamic var surname: String = String.sublimateDefault()

    convenience init(dto: SyncableDTO<DemoBetaObject>) {
        self.init()
        remoteId = dto.syncIdentifier()
        dto.update(object: self)
    }

    var clientCreatedDate : Date {
        return Date(timeIntervalSince1970: clientCreated)
    }

    var clientLastUpdatedDate : Date {
        return Date(timeIntervalSince1970: clientLastUpdated)
    }
}
