// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import Foundation
import Vapor
import Authentication

public func configureSublimateRoutes(plain : Router, resourceGroup: Router) {

    let peopleController = PeopleController()
    plain.get("people", use: peopleController.list)
    plain.post("people", use: peopleController.create)
    plain.delete("people", People.parameter, use: peopleController.delete)

    let speechesController = SpeechesController()
    resourceGroup.get("speeches", use: speechesController.list)
    resourceGroup.post("speeches", use: speechesController.create)
    resourceGroup.delete("speeches", Speeches.parameter, use: speechesController.delete)

}

class PeopleController {

    /// Returns the list
    func list(_ req: Request) throws -> Future<[People]> {

        return People.query(on: req).all()
    }

    /// Creation API
    func create(_ req: Request) throws -> Future<People> {
        return try req.content.decode(People.self).flatMap { people in
            return people.save(on: req)
        }
    }

    /// Deletion API
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(People.self).flatMap { people in
            return people.delete(on: req)
        }.transform(to: .ok)
    }
}
class SpeechesController {

    /// Returns the list
    func list(_ req: Request) throws -> Future<[Speeches]> {
        let user = try req.requireAuthenticated(PublicUser.self)

        return Speeches.query(on: req).filter(\Speeches.owner == user.userId).all()
    }

    /// Creation API
    func create(_ req: Request) throws -> Future<Speeches> {
        let user = try req.requireAuthenticated(PublicUser.self)
        return try req.content.decode(Speeches.self).flatMap { speeches in
            speeches.owner = user.userId
            return speeches.save(on: req)
        }
    }

    /// Deletion API
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        // GP TODO: Rewrite this to be more functional
        let user = try req.requireAuthenticated(PublicUser.self)

        let promise = req.eventLoop.newPromise(of: HTTPStatus.self)
        DispatchQueue.global().async {
            guard let param = try? req.parameters.next(Speeches.self).wait() else {
                promise.fail(error:Abort(HTTPResponseStatus.internalServerError))
                return
            }
            guard let objId = param.id?.uuidString else {
                promise.fail(error:Abort(HTTPResponseStatus.internalServerError))
                return
            }
            let uuid = UUID(objId)
            if let fetch = try? Speeches.query(on: req).filter(\Speeches.id == uuid).first().wait(), let object = fetch, object.owner == user.userId  {
                try? object.delete(on: req).wait()
            }
            promise.succeed(result: .ok)
        }
        return promise.futureResult
    }
}
