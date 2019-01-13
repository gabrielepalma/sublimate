// This file implements Bearer access JWT token authentication middleware
// I didn't use the protocols provided by Auth as Bearer authentication will not authorize a Fluent User but a different data structure, to keep Authentication layer fully separate from Resource Access layer. This hypothetically allows for a more distributed deployment.

import Vapor
import Authentication
import JWT

struct SublimateLoginBody : Codable {
    var grantType : String
    var refreshToken : String?
    var username : String?
    var password : String?

    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case refreshToken = "refresh_token"
        case username
        case password
    }
}

final class SublimateRefreshJwtTokenMiddleware<A>: Middleware where A: SublimateRefreshJwtAuthenticatable {

    public let signers: JWTSigners
    public init(authenticatable type: A.Type = A.self, signers: JWTSigners) {
        self.signers = signers
    }

    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        if try req.isAuthenticated(A.self) {
            return try next.respond(to: req)
        }

        return try req.content.decode(SublimateLoginBody.self).flatMap({ [signers] (object) -> Future<Response> in
            guard
                object.grantType == "refresh_token",
                let refreshToken = object.refreshToken,
                let jwtData = refreshToken.data(using: .utf8)
            else {
                return try next.respond(to: req)
            }

            guard let jwt = try? JWT< SublimateJwt.Payload>(from: jwtData, verifiedUsing: signers) else {
                return try next.respond(to: req)
            }
            guard jwt.payload.usage == SublimateJwt.RefreshToken.usage else {
                return try next.respond(to: req)
            }
            guard jwt.payload.iss.value == SublimateJwt.issuerClaim else {
                return try next.respond(to: req)
            }

            return A.authenticate(refreshJwt: jwt.payload, on: req).flatMap { a in
                if let a = a {
                    try req.authenticate(a)
                }
                return try next.respond(to: req)
            }
        })
    }
}

protocol SublimateRefreshJwtAuthenticatable : Authenticatable {
    static func authenticate(refreshJwt:  SublimateJwt.Payload, on connection: DatabaseConnectable) -> Future<Self?>
}

extension SublimateRefreshJwtAuthenticatable {
    static func sublimateRefreshJwtAuthMiddleware(signers: JWTSigners) -> SublimateRefreshJwtTokenMiddleware<Self> {
        return SublimateRefreshJwtTokenMiddleware(signers: signers)
    }
}
