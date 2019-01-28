// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import PromiseKit
import RxSwift
import SublimateSync

// MARK: - DemoPrivate network client
final class DemoPrivateNetworkClient: NetworkClient<DemoPrivateObject> {
    var networkManager : NetworkManagerProtocol

    init(networkManager : NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    override func fetchAll(withSyncingOptions options: NSDictionary?) -> Promise<[SyncableDTO<DemoPrivateObject>]> {
        let request = Request(method: .GET, contentType: .JSON, path: "demoPrivate")

        return Promise<[SyncableDTO<DemoPrivateObject>]>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: [DemoPrivateSyncableDTO.self]).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func syncOne(item: DemoPrivateObject) -> Promise<SyncableDTO<DemoPrivateObject>> {
        let body = try? JSONEncoder().encode(DemoPrivateSyncableDTO(from: item))
        let request = Request(method: .POST, contentType: .JSON, path: "demoPrivate", body: body)

        return Promise<SyncableDTO<DemoPrivateObject>>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: DemoPrivateSyncableDTO.self).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func delete(item: DemoPrivateObject) -> Promise<Void> {
        guard let remoteId = item.remoteId else {
            return Promise<Void>()
        }
        let request = Request(method: .DELETE, contentType: .JSON, path: "demoPrivate/\(remoteId)")
        return networkManager.makeRequest(request: request)
    }
}

// MARK: - DemoPublic network client
final class DemoPublicNetworkClient: NetworkClient<DemoPublicObject> {
    var networkManager : NetworkManagerProtocol

    init(networkManager : NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    override func fetchAll(withSyncingOptions options: NSDictionary?) -> Promise<[SyncableDTO<DemoPublicObject>]> {
        let request = Request(method: .GET, contentType: .JSON, path: "demoPublic")

        return Promise<[SyncableDTO<DemoPublicObject>]>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: [DemoPublicSyncableDTO.self]).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func syncOne(item: DemoPublicObject) -> Promise<SyncableDTO<DemoPublicObject>> {
        let body = try? JSONEncoder().encode(DemoPublicSyncableDTO(from: item))
        let request = Request(method: .POST, contentType: .JSON, path: "demoPublic", body: body)

        return Promise<SyncableDTO<DemoPublicObject>>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: DemoPublicSyncableDTO.self).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func delete(item: DemoPublicObject) -> Promise<Void> {
        guard let remoteId = item.remoteId else {
            return Promise<Void>()
        }
        let request = Request(method: .DELETE, contentType: .JSON, path: "demoPublic/\(remoteId)")
        return networkManager.makeRequest(request: request)
    }
}
