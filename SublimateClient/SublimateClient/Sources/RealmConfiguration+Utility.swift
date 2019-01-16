//
//  RealmConfiguration+Utility.swift
//  SublimateClient
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import UIKit
import RealmSwift

extension Realm.Configuration {
    static var sublimateSchemaVersion : UInt64 = 10000 // 1.(0)0.(0)0
    static func sublimate(objects : [Object.Type]? = nil) -> Realm.Configuration {

        let fileURL = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Sublimate.realm")
        var configuration = Realm.Configuration(fileURL: fileURL, objectTypes: objects)
        configuration.schemaVersion = sublimateSchemaVersion
        configuration.migrationBlock = { migration, oldSchemaVersion in
        }
        return configuration
    }
}
