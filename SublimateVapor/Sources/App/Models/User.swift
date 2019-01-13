//
//  UserAuthentication.swift
//  App
//
//  Created by i335287 on 02/01/2019.
//

import Foundation
import Vapor
import FluentSQLite
import Authentication

extension User : PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> { return \User.username }
    static var passwordKey: WritableKeyPath<User, String> { return \User.password }
}

extension User : SublimateRefreshJwtAuthenticatable {
    static func authenticate(refreshJwt: SublimateJwt.Payload, on connection: DatabaseConnectable) -> EventLoopFuture<User?> {

        let promise : Promise<User?> = connection.eventLoop.newPromise()
        // Joins seems to have issues with Fluent + SQLite :(
        // https://github.com/vapor/fluent/issues/563
        DispatchQueue.global().async {
            let tokenFetched = try? RefreshToken.query(on: connection).filter(\RefreshToken.refreshToken == refreshJwt.tokenId.value).first().wait()

            // We successfully fetched a RefreshToken for that token id
            guard let tryToken = tokenFetched, let token = tryToken else {
                promise.succeed(result: nil)
                return
            }
            let userFetched = try? User.query(on: connection).filter(\User.id == token.userId).first().wait()

            // We successfully fetched a user for that RefreshToken token id
            guard let tryUser = userFetched, let user = tryUser, let userId = user.id?.uuidString else {
                promise.succeed(result: nil)
                return
            }

            // The User associated to that RefreshToken is the same specified in the payload
            guard userId == refreshJwt.userId else {
                promise.succeed(result: nil)
                return
            }
            promise.succeed(result: user)
        }
        return promise.futureResult
    }

//        // We look in the DB for a RefreshToken that has the same token ID specified in the token payload
//        // We will also return the User associated to that RefreshToken
//        return RefreshToken.query(on: connection).filter(\RefreshToken.refreshToken == refreshJwt.tokenId.value).first()
//
//            .thenThrowing({ refresh -> User? in
//                // A RefreshToken with that token ID was found in the DB for a given User
//                guard let refresh = refresh  else {
//                    return nil
//                }
//                return User.query(on: connection).filter(\User.id == refresh.userId).first()
//            }).map({ result -> User? in
//                // A RefreshToken with that token ID was found in the DB for a given User
//                guard let user = result else {
//                    return nil
//                }
//
//                // The User associated to that RefreshToken is the same specified in the payload
//                guard user.id?.uuidString == refreshJwt.userId else {
//                    return nil
//                }
//
//                return user
//            })
//        }
}

extension PublicUser : SublimateBearerAuthenticatable {
    static func authenticate(bearerJwt:  SublimateJwt.Payload, eventLoop: EventLoop) -> EventLoopFuture<PublicUser?> {
        // The Middleware already validated the JWT, nothing else to be done here
        return eventLoop.future(PublicUser(userId: bearerJwt.userId))
    }
}

final class User: SQLiteUUIDModel {

    // Primary key
    var id: UUID?

    // TODO: How to specificy SQLite that this field is a unique index despise not a primary key?
    var username: String

    // Hashed password
    var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

// Response after new registration or logout; authorized object for resource routes
struct PublicUser: Content {
    var userId: String
}

// Request for user creation
struct UserCreationBody : Codable {
    var username: String
    var password: String

    func validate() -> Bool {
        return username.count > 0 && password.count > 0
    }
}

// Response for login routes
struct AuthorizedUser: Content {
    var userId: String
    var username: String
    var refreshToken: String
    var accessToken: String
}

extension User: Content   { }
extension User: Parameter { }
extension User: Migration {
    static func prepare(on connection: SQLiteConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.username)
        }
    }
}
