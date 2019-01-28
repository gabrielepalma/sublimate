// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import RealmSwift
import Swinject
import PromiseKit
import Reachability
import SublimateSync

func registerObjectSyncers(container : Container) {

    container.register(NetworkClient<DemoPrivateObject>.self, factory: { (r) -> NetworkClient<DemoPrivateObject> in
        return DemoPrivateNetworkClient(networkManager: r.resolve(NetworkManagerProtocol.self)!)
    }).inObjectScope(.weak)

    container.register(Syncer<DemoPrivateObject>.self) { (r) -> Syncer<DemoPrivateObject> in
        return Syncer<DemoPrivateObject>(networkClient: r.resolve(NetworkClient<DemoPrivateObject>.self)!, realmConfiguration: r.resolve(Realm.Configuration.self)!, reachability: r.resolve(Reachability.self)!)
    }.inObjectScope(.weak)

    container.register(NetworkClient<DemoPublicObject>.self, factory: { (r) -> NetworkClient<DemoPublicObject> in
        return DemoPublicNetworkClient(networkManager: r.resolve(NetworkManagerProtocol.self)!)
    }).inObjectScope(.weak)

    container.register(Syncer<DemoPublicObject>.self) { (r) -> Syncer<DemoPublicObject> in
        return Syncer<DemoPublicObject>(networkClient: r.resolve(NetworkClient<DemoPublicObject>.self)!, realmConfiguration: r.resolve(Realm.Configuration.self)!, reachability: r.resolve(Reachability.self)!)
    }.inObjectScope(.weak)

}

func sublimateObjectTypes() -> [Object.Type]? {
    return [
        DemoPrivateObject.self, 
        DemoPublicObject.self
    ]
}

func sublimatePrivateObjectTypes() -> [Object.Type]? {
    return [
        DemoPrivateObject.self
    ]
}

extension DI {
    static var demoPrivateNetworkClient : NetworkClient<DemoPrivateObject>? {
        get {
            return box.resolve(NetworkClient<DemoPrivateObject>.self)
        }
    }
    static var demoPrivateSyncer : Syncer<DemoPrivateObject>? {
        get {
            return box.resolve(Syncer<DemoPrivateObject>.self)
        }
    }
    static var demoPublicNetworkClient : NetworkClient<DemoPublicObject>? {
        get {
            return box.resolve(NetworkClient<DemoPublicObject>.self)
        }
    }
    static var demoPublicSyncer : Syncer<DemoPublicObject>? {
        get {
            return box.resolve(Syncer<DemoPublicObject>.self)
        }
    }
}
