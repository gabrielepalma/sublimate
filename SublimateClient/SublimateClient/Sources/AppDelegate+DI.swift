//
//  SublimateSyncManager.swift
//  SublimateClient
//
//  Created by i335287 on 29/11/2018.
//  Copyright © 2018 Gabriele. All rights reserved.
//

import Foundation
import RealmSwift
import Swinject
import Reachability
import SublimateSync

class DI {
    public static let box : Container = Container()
}

extension AppDelegate {
    func initSublimateDependencies() {

        DI.box.register(Reachability.self) { r -> Reachability in
            let reachability = Reachability()!
            try! reachability.startNotifier()
            return reachability
        }.inObjectScope(.container)

        DI.box.register(Realm.Configuration.self) { (r) -> Realm.Configuration in
            return Realm.Configuration.sublimate(objects: sublimateObjectTypes())
            }.inObjectScope(.container)

        DI.box.register(Realm.Configuration.self, name: DI.RealmConfigurationPrivateOnly) { (r) -> Realm.Configuration in
            return Realm.Configuration.sublimate(objects: sublimatePrivateObjectTypes())
            }.inObjectScope(.container)

        DI.box.register(NetworkConfigurationProtocol.self) { (r) -> NetworkConfigurationProtocol in
            return NetworkConfiguration()
        }.inObjectScope(.container)

        DI.box.register(AuthenticationClientProtocol.self) { (r) -> AuthenticationClientProtocol in
            return AuthenticationClient(
                networkConfiguration: r.resolve(NetworkConfigurationProtocol.self)!)
            }.inObjectScope(.graph)

        DI.box.register(AuthenticationManagerProtocol.self) { (r) -> AuthenticationManagerProtocol in
            return AuthenticationManager(
                client: r.resolve(AuthenticationClientProtocol.self)!)
            }.inObjectScope(.container)

        DI.box.register(NetworkManagerProtocol.self) { (r) -> NetworkManagerProtocol in
            return NetworkManager(
                networkConfiguration: r.resolve(NetworkConfigurationProtocol.self)!,
                authManager: r.resolve(AuthenticationManagerProtocol.self)!)
        }.inObjectScope(.weak)
    }
}

extension DI {
    static var authenticationManager : AuthenticationManagerProtocol? {
        get {
            return DI.box.resolve(AuthenticationManagerProtocol.self)
        }
    }

    static public let RealmConfigurationPrivateOnly = "OwnedOnly"
    static var realmConfiguration : Realm.Configuration? {
        get {
            return DI.box.resolve(Realm.Configuration.self)
        } 
    }
}
