import Foundation
import Vapor
import Authentication
import JWT

struct LoginBody : Codable {
    var refreshToken : String?
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

struct LogoutBody : Codable {
    var refreshToken : String
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

final class UserController {

    func createUser(_ request: Request) throws -> Future<PublicUser> {
        return try request.content.decode(UserCreationBody.self).flatMap(to: PublicUser.self) { user in
            guard user.validate() else {
                throw Abort(HTTPResponseStatus.badRequest)
            }
            let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
            let newUser = User(username: user.username, password: passwordHashed)
            return newUser.save(on: request).map(to: PublicUser.self) { createdUser in
                guard let uuid = createdUser.id?.uuidString else {
                    throw Abort(HTTPResponseStatus.internalServerError)
                }
                let publicUser = PublicUser(userId: uuid, isAdmin: newUser.isAdmin)
                return publicUser
            }
        }
    }

    func loginUser(_ request: Request) throws -> Future<AuthorizedUser>
    {
        let minimumTimeToLiveForRefreshToken : Double = 60 * 60 * 24 * 30 // One month
        let user = try request.requireAuthenticated(User.self)
        guard let userId = user.id else {
            throw Abort(HTTPResponseStatus.internalServerError)
        }
        let accessTokenString = try user.createJwt(usage: SublimateJwt.AccessToken.usage, expiration: SublimateJwt.AccessToken.expiration).0
        let promise = request.eventLoop.newPromise(of: AuthorizedUser.self)
        DispatchQueue.global().async {
            // Decode the body
            guard let decodedBody = try? request.content.decode(LoginBody.self).wait() else {
                promise.fail(error: Abort(HTTPResponseStatus.badRequest))
                return
            }
            let refreshTokenString : String
            // If a token was given, do token cleaning and reissuing operations, otherwise just create a new one
            if let givenTokenString = decodedBody.refreshToken, let data = givenTokenString.data(using: .utf8),
                let givenToken = try? JWT< SublimateJwt.Payload>(unverifiedFrom: data)
            {
                // Delete, if existing, the refresh token that was replaced by the one used in this requet
                // This is now safe as we have proof the new refresh token was successfully received by the client
                try? RefreshToken.query(on: request).filter(\RefreshToken.issuedToReplace == givenToken.payload.tokenId.value).delete().wait()
                let queried = try? RefreshToken.query(on: request).filter(\RefreshToken.refreshToken == givenToken.payload.tokenId.value).first().wait()
                guard let fetched = queried, fetched != nil else {
                    promise.fail(error: Abort(HTTPResponseStatus.unauthorized))
                    return
                }

                // Check if given token is about to expire and we want to replace it
                let timeToLive = givenToken.payload.exp.value.timeIntervalSince1970 - Date().timeIntervalSince1970
                if timeToLive < minimumTimeToLiveForRefreshToken {
                    // Create and save the new token
                    guard let result = newToken(for: user, on: request, toReplace: givenTokenString) else {
                        promise.fail(error: Abort(HTTPResponseStatus.internalServerError))
                        return
                    }
                    refreshTokenString = result
                }
                else {
                    // We don't need to reissue the refresh token, we return back the old one, no changes in database
                    refreshTokenString = givenTokenString
                }
            }
            else {
                // Create and save the new token
                guard let result = newToken(for: user, on: request, toReplace: nil) else {
                    promise.fail(error: Abort(HTTPResponseStatus.internalServerError))
                    return
                }
                refreshTokenString = result
            }
            promise.succeed(result: AuthorizedUser(userId: userId.uuidString, username: user.username, refreshToken: refreshTokenString, accessToken: accessTokenString))
        }
        return promise.futureResult
    }

    func logout(_ request: Request) throws -> Future<PublicUser> {
        let user = try request.requireAuthenticated(User.self)
        guard let userId = user.id else {
            throw Abort(HTTPResponseStatus.internalServerError)
        }
        let promise = request.eventLoop.newPromise(of: PublicUser.self)
        DispatchQueue.global().async {
            guard let decodedBody = try? request.content.decode(LoginBody.self).wait() else {
                promise.fail(error: Abort(HTTPResponseStatus.badRequest))
                return
            }
            guard let givenTokenString = decodedBody.refreshToken, let data = givenTokenString.data(using: .utf8),
                let givenToken = try? JWT< SublimateJwt.Payload>(unverifiedFrom: data) else {
                    promise.fail(error: Abort(HTTPResponseStatus.badRequest))
                    return
            }
            try? RefreshToken.query(on: request).filter(\RefreshToken.refreshToken == givenToken.payload.tokenId.value).delete().wait()
            promise.succeed(result: PublicUser(userId: userId.uuidString, isAdmin: user.isAdmin))
        }
        return promise.futureResult
    }
}

func newToken(for user: User, on connection: DatabaseConnectable, toReplace: String?) -> String? {
    guard let userId = user.id else {
        return nil
    }
    // We create a new token
    guard let newToken = try? user.createJwt(usage: SublimateJwt.RefreshToken.usage, expiration: SublimateJwt.RefreshToken.expiration) else {
        return nil
    }
    // We save the new token in the database
    guard let _ = try? RefreshToken(refreshToken: newToken.1.tokenId.value, userId: userId, expiresAt: newToken.1.exp.value.timeIntervalSince1970, issuedToReplace: toReplace).save(on: connection).wait() else {
        return nil
    }
    return newToken.0
}
