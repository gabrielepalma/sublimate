// This file implements Bearer access JWT token authentication middleware
// I didn't use the protocols provided by Auth as Bearer authentication will not authorize a Fluent User but a different data structure, to keep Authentication layer fully separate from Resource Access layer. This hypothetically allows for a more distributed deployment.

import Vapor
import Authentication
import JWT

final class SublimateBearerAuthenticationMiddleware<A>: Middleware where A: SublimateBearerAuthenticatable {

    public let signers: JWTSigners
    public init(authenticatable type: A.Type = A.self, signers: JWTSigners) {
        self.signers = signers
    }

    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        if try req.isAuthenticated(A.self) {
            return try next.respond(to: req)
        }

        guard let token = req.http.headers.bearerAuthorization, let jwtData = token.token.data(using: .utf8)  else {
            return try next.respond(to: req)
        }

        guard let jwt = try? JWT< SublimateJwt.Payload>(from: jwtData, verifiedUsing: signers) else {
            return try next.respond(to: req)
        }
        guard jwt.payload.usage == SublimateJwt.AccessToken.usage else {
             return try next.respond(to: req)
        }
        guard jwt.payload.iss.value == SublimateJwt.issuerClaim else {
            return try next.respond(to: req)
        }
        return A.authenticate(bearerJwt: jwt.payload, eventLoop: req.eventLoop).flatMap { a in
            if let a = a {
                try req.authenticate(a)
            }
            return try next.respond(to: req)
        }
    }
}

protocol SublimateBearerAuthenticatable : Authenticatable {
    static func authenticate(bearerJwt:  SublimateJwt.Payload, eventLoop: EventLoop) -> Future<Self?>
}

extension SublimateBearerAuthenticatable {
    public static func sublimateBearerAuthMiddleware(signers: JWTSigners) -> SublimateBearerAuthenticationMiddleware<Self> {
        return SublimateBearerAuthenticationMiddleware(signers: signers)
    }
}
