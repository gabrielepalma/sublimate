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

    container.register(NetworkClient<PeopleObject>.self, factory: { (r) -> NetworkClient<PeopleObject> in
        return PeopleNetworkClient(networkManager: r.resolve(NetworkManagerProtocol.self)!)
    }).inObjectScope(.weak)

    container.register(Syncer<PeopleObject>.self) { (r) -> Syncer<PeopleObject> in
        return Syncer<PeopleObject>(networkClient: r.resolve(NetworkClient<PeopleObject>.self)!, realmConfiguration: r.resolve(Realm.Configuration.self)!, reachability: r.resolve(Reachability.self)!)
    }.inObjectScope(.weak)

    container.register(NetworkClient<SpeechesObject>.self, factory: { (r) -> NetworkClient<SpeechesObject> in
        return SpeechesNetworkClient(networkManager: r.resolve(NetworkManagerProtocol.self)!)
    }).inObjectScope(.weak)

    container.register(Syncer<SpeechesObject>.self) { (r) -> Syncer<SpeechesObject> in
        return Syncer<SpeechesObject>(networkClient: r.resolve(NetworkClient<SpeechesObject>.self)!, realmConfiguration: r.resolve(Realm.Configuration.self)!, reachability: r.resolve(Reachability.self)!)
    }.inObjectScope(.weak)

}

func sublimateObjectTypes() -> [Object.Type]? {
    return [
        PeopleObject.self, 
        SpeechesObject.self
    ]
}

func sublimatePrivateObjectTypes() -> [Object.Type]? {
    return [
        SpeechesObject.self
    ]
}

extension DI {
    static var peopleNetworkClient : NetworkClient<PeopleObject>? {
        get {
            return box.resolve(NetworkClient<PeopleObject>.self)
        }
    }
    static var peopleSyncer : Syncer<PeopleObject>? {
        get {
            return box.resolve(Syncer<PeopleObject>.self)
        }
    }
    static var speechesNetworkClient : NetworkClient<SpeechesObject>? {
        get {
            return box.resolve(NetworkClient<SpeechesObject>.self)
        }
    }
    static var speechesSyncer : Syncer<SpeechesObject>? {
        get {
            return box.resolve(Syncer<SpeechesObject>.self)
        }
    }
}
