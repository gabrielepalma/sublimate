// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import Foundation
import Vapor
import Authentication

public func configureSublimateRoutes(plain : Router, resourceGroup: Router) {

    let demoPrivateController = DemoPrivateController()
    resourceGroup.get("demoPrivate", use: demoPrivateController.list)
    resourceGroup.post("demoPrivate", use: demoPrivateController.create)
    resourceGroup.delete("demoPrivate", DemoPrivate.parameter, use: demoPrivateController.delete)

    let demoPublicController = DemoPublicController()
    plain.get("demoPublic", use: demoPublicController.list)
    plain.post("demoPublic", use: demoPublicController.create)
    plain.delete("demoPublic", DemoPublic.parameter, use: demoPublicController.delete)

}

class DemoPrivateController {

    /// Returns the list
    func list(_ req: Request) throws -> Future<[DemoPrivate]> {
        let user = try req.requireAuthenticated(PublicUser.self)

        return DemoPrivate.query(on: req).filter(\DemoPrivate.owner == user.userId).all()
    }

    /// Creation API
    func create(_ req: Request) throws -> Future<DemoPrivate> {
        let user = try req.requireAuthenticated(PublicUser.self)
        return try req.content.decode(DemoPrivate.self)
            .map ({ item -> DemoPrivate in
                item.owner = user.userId
                item.remoteCreated = Date().timeIntervalSince1970
                return item
            })
            .flatMap({ decoded -> Future<DemoPrivate> in
                guard let id = decoded.id else {
                    return req.future(decoded)
                }
                return DemoPrivate.find(id, on: req)
                    .flatMap({ found -> Future<DemoPrivate> in
                        guard let found = found else {
                            return req.future(error: Abort(HTTPResponseStatus.notFound))
                        }
                        guard found.owner == user.userId else {
                            return req.future(error: Abort(HTTPResponseStatus.unauthorized))
                        }
                        decoded.remoteCreated = found.remoteCreated
                        decoded.clientCreated = found.clientCreated
                        return req.future(decoded)
                    })
            })
            .then({ toBeSaved -> Future<DemoPrivate> in
                return toBeSaved.save(on: req)
            })
    }

    /// Deletion API
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        // GP TODO: Rewrite this to be more functional
        let user = try req.requireAuthenticated(PublicUser.self)

        let promise = req.eventLoop.newPromise(of: HTTPStatus.self)
        DispatchQueue.global().async {
            guard let param = try? req.parameters.next(DemoPrivate.self).wait() else {
                promise.fail(error:Abort(HTTPResponseStatus.internalServerError))
                return
            }
            guard let objId = param.id?.uuidString else {
                promise.fail(error:Abort(HTTPResponseStatus.internalServerError))
                return
            }
            let uuid = UUID(objId)
            if let fetch = try? DemoPrivate.query(on: req).filter(\DemoPrivate.id == uuid).first().wait(), let object = fetch, object.owner == user.userId  {
                try? object.delete(on: req).wait()
            }
            promise.succeed(result: .ok)
        }
        return promise.futureResult
    }
}
class DemoPublicController {

    /// Returns the list
    func list(_ req: Request) throws -> Future<[DemoPublic]> {

        return DemoPublic.query(on: req).all()
    }

    /// Creation API
    func create(_ req: Request) throws -> Future<DemoPublic> {
        return try req.content.decode(DemoPublic.self)
            .map ({ item -> DemoPublic in
                item.remoteCreated = Date().timeIntervalSince1970
                return item
            })
            .flatMap({ decoded -> Future<DemoPublic> in
                guard let id = decoded.id else {
                    return req.future(decoded)
                }
                return DemoPublic.find(id, on: req)
                    .flatMap({ found -> Future<DemoPublic> in
                        guard let found = found else {
                            return req.future(error: Abort(HTTPResponseStatus.notFound))
                        }
                        decoded.remoteCreated = found.remoteCreated
                        decoded.clientCreated = found.clientCreated
                        return req.future(decoded)
                    })
            })
            .then({ toBeSaved -> Future<DemoPublic> in
                return toBeSaved.save(on: req)
            })
    }

    /// Deletion API
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(DemoPublic.self).flatMap { demoPublic in
            return demoPublic.delete(on: req)
        }.transform(to: .ok)
    }
}
