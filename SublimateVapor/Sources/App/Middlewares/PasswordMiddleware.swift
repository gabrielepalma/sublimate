// This file implements Bearer access JWT token authentication middleware
// I didn't use the protocols provided by Auth as Bearer authentication will not authorize a Fluent User but a different data structure, to keep Authentication layer fully separate from Resource Access layer. This hypothetically allows for a more distributed deployment.

import Vapor
import Authentication

final class SublimatePasswordAuthenticationMiddleware<A>: Middleware where A: PasswordAuthenticatable {

    public let verifier: PasswordVerifier
    public init(authenticatable type: A.Type = A.self, verifier: PasswordVerifier) {
        self.verifier = verifier
    }

    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        if try req.isAuthenticated(A.self) {
            return try next.respond(to: req)
        }

        return try req.content.decode(SublimateLoginBody.self).flatMap({ [verifier] (object) -> Future<Response> in
            guard object.grantType == "password" else {
                return try next.respond(to: req)
            }
            guard let username = object.username, let password = object.password else {
                return try next.respond(to: req)
            }

            return A.authenticate(using: BasicAuthorization(username: username, password: password), verifier: verifier, on: req).flatMap { a in
                if let a = a {
                    try req.authenticate(a)
                }
                return try next.respond(to: req)
            }
        })
    }
}

extension PasswordAuthenticatable {
    static func sublimatePasswordAuthMiddleware(using verifier: PasswordVerifier) -> SublimatePasswordAuthenticationMiddleware<Self> {
        return SublimatePasswordAuthenticationMiddleware(verifier: verifier)
    }
}
