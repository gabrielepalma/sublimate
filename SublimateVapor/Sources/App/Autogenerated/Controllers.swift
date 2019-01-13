// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import Foundation
import Vapor
import Authentication

public func configureSublimateRoutes(plain : Router, resourceGroup: Router) {
    let demoAlphaController = DemoAlphaController()
    plain.get("demoAlpha", use: demoAlphaController.list)
    plain.post("demoAlpha", use: demoAlphaController.create)
    plain.delete("demoAlpha", DemoAlpha.parameter, use: demoAlphaController.delete)

    let demoBetaController = DemoBetaController()
    resourceGroup.get("demoBeta", use: demoBetaController.list)
    resourceGroup.post("demoBeta", use: demoBetaController.create)
    resourceGroup.delete("demoBeta", DemoBeta.parameter, use: demoBetaController.delete)
}

class DemoAlphaController {

    /// Returns the list
    func list(_ req: Request) throws -> Future<[DemoAlpha]> {
        return DemoAlpha.query(on: req).all()
    }

    /// Creation API
    func create(_ req: Request) throws -> Future<DemoAlpha> {
        return try req.content.decode(DemoAlpha.self).flatMap { demoAlpha in
            return demoAlpha.save(on: req)
        }
    }

    /// Deletion API
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(DemoAlpha.self).flatMap { demoAlpha in
            return demoAlpha.delete(on: req)
        }.transform(to: .ok)
    }
}
class DemoBetaController {

    /// Returns the list
    func list(_ req: Request) throws -> Future<[DemoBeta]> {
        let user = try req.requireAuthenticated(PublicUser.self)
        return DemoBeta.query(on: req).filter(\DemoBeta.owner == user.userId).all()
    }

    /// Creation API
    func create(_ req: Request) throws -> Future<DemoBeta> {
        let user = try req.requireAuthenticated(PublicUser.self)
        return try req.content.decode(DemoBeta.self).flatMap { demoBeta in
            demoBeta.owner = user.userId
            return demoBeta.save(on: req)
        }
    }

    /// Deletion API
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        let user = try req.requireAuthenticated(PublicUser.self)

        let promise = req.eventLoop.newPromise(of: HTTPStatus.self)
        DispatchQueue.global().async {
            guard let param = try? req.parameters.next(DemoBeta.self).wait() else {
                promise.fail(error:Abort(HTTPResponseStatus.internalServerError))
                return
            }
            guard let objId = param.id?.uuidString else {
                promise.fail(error:Abort(HTTPResponseStatus.internalServerError))
                return
            }
            let uuid = UUID(objId)
            if let fetch = try? DemoBeta.query(on: req).filter(\DemoBeta.id == uuid).first().wait(), let object = fetch, object.owner == user.userId  {
                try? object.delete(on: req).wait()
            }
            promise.succeed(result: .ok)
        }
        return promise.futureResult
    }
}
