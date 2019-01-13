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

    container.register(NetworkClient<DemoAlphaObject>.self, factory: { (r) -> NetworkClient<DemoAlphaObject> in
        return DemoAlphaNetworkClient(networkManager: r.resolve(NetworkManagerProtocol.self)!)
    }).inObjectScope(.weak)

    container.register(Syncer<DemoAlphaObject>.self) { (r) -> Syncer<DemoAlphaObject> in
        return Syncer<DemoAlphaObject>(networkClient: r.resolve(NetworkClient<DemoAlphaObject>.self)!, realmConfiguration: r.resolve(Realm.Configuration.self)!, reachability: r.resolve(Reachability.self)!)
    }.inObjectScope(.weak)

    container.register(NetworkClient<DemoBetaObject>.self, factory: { (r) -> NetworkClient<DemoBetaObject> in
        return DemoBetaNetworkClient(networkManager: r.resolve(NetworkManagerProtocol.self)!)
    }).inObjectScope(.weak)

    container.register(Syncer<DemoBetaObject>.self) { (r) -> Syncer<DemoBetaObject> in
        return Syncer<DemoBetaObject>(networkClient: r.resolve(NetworkClient<DemoBetaObject>.self)!, realmConfiguration: r.resolve(Realm.Configuration.self)!, reachability: r.resolve(Reachability.self)!)
    }.inObjectScope(.weak)

}

func sublimateObjectTypes() -> [Object.Type]? {
    return [
        DemoAlphaObject.self, 
        DemoBetaObject.self
    ]
}

func sublimatePrivateObjectTypes() -> [Object.Type]? {
    return [
        DemoBetaObject.self
    ]
}

extension DI {
    static var demoAlphaNetworkClient : NetworkClient<DemoAlphaObject>? {
        get {
            return box.resolve(NetworkClient<DemoAlphaObject>.self)
        }
    }
    static var demoAlphaSyncer : Syncer<DemoAlphaObject>? {
        get {
            return box.resolve(Syncer<DemoAlphaObject>.self)
        }
    }
    static var demoBetaNetworkClient : NetworkClient<DemoBetaObject>? {
        get {
            return box.resolve(NetworkClient<DemoBetaObject>.self)
        }
    }
    static var demoBetaSyncer : Syncer<DemoBetaObject>? {
        get {
            return box.resolve(Syncer<DemoBetaObject>.self)
        }
    }
}
