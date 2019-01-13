// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import PromiseKit
import RxSwift
import SublimateSync

// MARK: - DemoAlpha network client
final class DemoAlphaNetworkClient: NetworkClient<DemoAlphaObject> {
    var networkManager : NetworkManagerProtocol

    init(networkManager : NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    override func fetchAll(withSyncingOptions options: NSDictionary?) -> Promise<[SyncableDTO<DemoAlphaObject>]> {
        let request = Request(method: .GET, contentType: .JSON, path: "demoAlpha")

        return Promise<[SyncableDTO<DemoAlphaObject>]>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: [DemoAlphaSyncableDTO.self]).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func syncOne(item: DemoAlphaObject) -> Promise<SyncableDTO<DemoAlphaObject>> {
        let body = try? JSONEncoder().encode(DemoAlphaSyncableDTO(from: item))
        let request = Request(method: .POST, contentType: .JSON, path: "demoAlpha", body: body)

        return Promise<SyncableDTO<DemoAlphaObject>>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: DemoAlphaSyncableDTO.self).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func delete(item: DemoAlphaObject) -> Promise<Void> {
        guard let remoteId = item.remoteId else {
            return Promise<Void>()
        }
        let request = Request(method: .DELETE, contentType: .JSON, path: "demoAlpha/\(remoteId)")
        return networkManager.makeRequest(request: request)
    }
}

// MARK: - DemoBeta network client
final class DemoBetaNetworkClient: NetworkClient<DemoBetaObject> {
    var networkManager : NetworkManagerProtocol

    init(networkManager : NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    override func fetchAll(withSyncingOptions options: NSDictionary?) -> Promise<[SyncableDTO<DemoBetaObject>]> {
        let request = Request(method: .GET, contentType: .JSON, path: "demoBeta")

        return Promise<[SyncableDTO<DemoBetaObject>]>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: [DemoBetaSyncableDTO.self]).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func syncOne(item: DemoBetaObject) -> Promise<SyncableDTO<DemoBetaObject>> {
        let body = try? JSONEncoder().encode(DemoBetaSyncableDTO(from: item))
        let request = Request(method: .POST, contentType: .JSON, path: "demoBeta", body: body)

        return Promise<SyncableDTO<DemoBetaObject>>(resolver: { (resolver) in
            networkManager.makeRequest(request: request, responseType: DemoBetaSyncableDTO.self).done({ (response) in
                resolver.fulfill(response)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }

    override func delete(item: DemoBetaObject) -> Promise<Void> {
        guard let remoteId = item.remoteId else {
            return Promise<Void>()
        }
        let request = Request(method: .DELETE, contentType: .JSON, path: "demoBeta/\(remoteId)")
        return networkManager.makeRequest(request: request)
    }
}
