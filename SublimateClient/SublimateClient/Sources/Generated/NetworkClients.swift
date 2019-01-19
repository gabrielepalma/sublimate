// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import PromiseKit
import RxSwift
import SublimateSync

// MARK: - People network client
final class PeopleNetworkClient: NetworkClient<PeopleObject> {
    var networkManager : NetworkManagerProtocol

    init(networkManager : NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    override func fetchAll(withSyncingOptions options: NSDictionary?) -> Promise<[SyncableDTO<PeopleObject>]> {
        let request = Request(method: .GET, contentType: .JSON, path: "people")

        return Promise<[SyncableDTO<PeopleObject>]>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: [PeopleSyncableDTO.self]).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func syncOne(item: PeopleObject) -> Promise<SyncableDTO<PeopleObject>> {
        let body = try? JSONEncoder().encode(PeopleSyncableDTO(from: item))
        let request = Request(method: .POST, contentType: .JSON, path: "people", body: body)

        return Promise<SyncableDTO<PeopleObject>>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: PeopleSyncableDTO.self).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func delete(item: PeopleObject) -> Promise<Void> {
        guard let remoteId = item.remoteId else {
            return Promise<Void>()
        }
        let request = Request(method: .DELETE, contentType: .JSON, path: "people/\(remoteId)")
        return networkManager.makeRequest(request: request)
    }
}

// MARK: - Speeches network client
final class SpeechesNetworkClient: NetworkClient<SpeechesObject> {
    var networkManager : NetworkManagerProtocol

    init(networkManager : NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    override func fetchAll(withSyncingOptions options: NSDictionary?) -> Promise<[SyncableDTO<SpeechesObject>]> {
        let request = Request(method: .GET, contentType: .JSON, path: "speeches")

        return Promise<[SyncableDTO<SpeechesObject>]>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: [SpeechesSyncableDTO.self]).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func syncOne(item: SpeechesObject) -> Promise<SyncableDTO<SpeechesObject>> {
        let body = try? JSONEncoder().encode(SpeechesSyncableDTO(from: item))
        let request = Request(method: .POST, contentType: .JSON, path: "speeches", body: body)

        return Promise<SyncableDTO<SpeechesObject>>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: SpeechesSyncableDTO.self).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func delete(item: SpeechesObject) -> Promise<Void> {
        guard let remoteId = item.remoteId else {
            return Promise<Void>()
        }
        let request = Request(method: .DELETE, contentType: .JSON, path: "speeches/\(remoteId)")
        return networkManager.makeRequest(request: request)
    }
}
