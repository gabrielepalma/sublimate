// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import RealmSwift
import SublimateSync

// MARK: - DemoPrivate Realm object
final class DemoPrivateObject: Object, Syncable {
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
    @objc dynamic var remoteCreated: Double = Date().timeIntervalSince1970
    @objc dynamic var localId: String = UUID().uuidString
    @objc private dynamic var realmSyncOperation : String = SyncOperation.none.rawValue

    @objc dynamic var title: String = String.sublimateDefault()
    @objc dynamic var content: String = String.sublimateDefault()
    @objc dynamic var duration: Int = Int.sublimateDefault()
    @objc dynamic var grade: Double = Double.sublimateDefault()

    convenience init(dto: SyncableDTO<DemoPrivateObject>) {
        self.init()
        remoteId = dto.syncIdentifier()
        dto.update(object: self)
    }

    var clientCreatedDate : Date {
        return Date(timeIntervalSince1970: clientCreated)
    }

    var remoteCreatedDate : Date {
        return Date(timeIntervalSince1970: remoteCreated)
    }

    var clientLastUpdatedDate : Date {
        return Date(timeIntervalSince1970: clientLastUpdated)
    }
}

// MARK: - DemoPublic Realm object
final class DemoPublicObject: Object, Syncable {
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
    @objc dynamic var remoteCreated: Double = Date().timeIntervalSince1970
    @objc dynamic var localId: String = UUID().uuidString
    @objc private dynamic var realmSyncOperation : String = SyncOperation.none.rawValue

    @objc dynamic var name: String = String.sublimateDefault()
    @objc dynamic var surname: String = String.sublimateDefault()
    @objc dynamic var email: String = String.sublimateDefault()
    @objc dynamic var age: Int = Int.sublimateDefault()
    @objc dynamic var weight: Double = Double.sublimateDefault()

    convenience init(dto: SyncableDTO<DemoPublicObject>) {
        self.init()
        remoteId = dto.syncIdentifier()
        dto.update(object: self)
    }

    var clientCreatedDate : Date {
        return Date(timeIntervalSince1970: clientCreated)
    }

    var remoteCreatedDate : Date {
        return Date(timeIntervalSince1970: remoteCreated)
    }

    var clientLastUpdatedDate : Date {
        return Date(timeIntervalSince1970: clientLastUpdated)
    }
}
