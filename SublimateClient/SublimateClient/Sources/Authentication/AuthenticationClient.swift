//
//  AuthenticationClient.swift
//  SublimateClient
//
//  Created by i335287 on 05/01/2019.
//  Copyright © 2019 Gabriele. All rights reserved.
//

import UIKit
import PromiseKit
import SublimateSync

class AuthenticationClient : AuthenticationClientProtocol {

    var networkConfiguration : NetworkConfigurationProtocol

    init(networkConfiguration : NetworkConfigurationProtocol) {
        self.networkConfiguration = networkConfiguration
    }

    struct AuthenticatedResponse: Codable {
        var userId: String
        var username: String
        var refreshToken: String
        var accessToken: String
    }

    // Login with Username

    struct LoginRequest : Codable {
        let grantType : String = "password"
        var username : String
        var password : String

        enum CodingKeys: String, CodingKey {
            case grantType = "grant_type"
            case username
            case password
        }
    }

    func loginWithUserCredentials(username: String, password: String) -> Promise<Authorizations> {
        guard let body = try? JSONEncoder().encode(LoginRequest(username: username, password: password)) else {
            return Promise<Authorizations>(error: NSError(domain: "sublimate.authentication.refresh", code: 900, userInfo: ["reason" : "Unable to encode body"]))
        }
        guard let base = URL(string: networkConfiguration.baseUrl) else {
            return Promise<Authorizations>(error: NSError(domain: "sublimate.authentication.refresh", code: 900, userInfo: ["reason" : "URL was invalid "] ))
        }

        var urlRequest = URLRequest(url: base.appendingPathComponent("token"))
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        urlRequest.httpMethod = "POST"

        return URLSession.shared.dataTask(.promise, with: urlRequest).validate()
            .map { (response : (data: Data, response: URLResponse)) -> AuthenticatedResponse in
                return try JSONDecoder().decode(AuthenticatedResponse.self, from: response.data)
            }
            .map({ response -> Authorizations in
                let user = UserInfo(username: response.username, userId: response.userId)
                let tokens = TokenInfo(accessToken: response.accessToken, refreshToken: response.refreshToken)
                return (user, tokens)
            })
    }

    // Login with Refresh Token

    struct RefreshRequest : Codable {
        let grantType : String = "refresh_token"
        var refreshToken : String

        enum CodingKeys: String, CodingKey {
            case grantType = "grant_type"
            case refreshToken = "refresh_token"
        }
    }

    func loginWithRefreshToken(refreshToken: String) -> Promise<Authorizations> {
        guard let body = try? JSONEncoder().encode(RefreshRequest(refreshToken: refreshToken)) else {
            return Promise<Authorizations>(error: NSError(domain: "sublimate.authentication.refresh", code: 900, userInfo: ["reason" : "Unable to encode body"]))
        }
        guard let base = URL(string: networkConfiguration.baseUrl) else {
            return Promise<Authorizations>(error: NSError(domain: "sublimate.authentication.refresh", code: 900, userInfo: ["reason" : "URL was invalid "] ))
        }

        var urlRequest = URLRequest(url: base.appendingPathComponent("token"))
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        urlRequest.httpMethod = "POST"

        return URLSession.shared.dataTask(.promise, with: urlRequest).validate()
            .map { (response : (data: Data, response: URLResponse)) -> AuthenticatedResponse in
                return try JSONDecoder().decode(AuthenticatedResponse.self, from: response.data)
            }
            .map({ response -> Authorizations in
                let user = UserInfo(username: response.username, userId: response.userId)
                let tokens = TokenInfo(accessToken: response.accessToken, refreshToken: response.refreshToken)
                return (user, tokens)
            })
    }

    // MARK: Logout

    struct LogoutRequest : Codable {
        let grantType : String = "refresh_token"
        var refreshToken : String
        enum CodingKeys: String, CodingKey {
            case grantType = "grant_type"
            case refreshToken = "refresh_token"
        }
    }

    struct LogoutResponse : Codable {
        var userId : String
    }

    func logout(refreshToken: String) -> Promise<Void> {
        guard let body = try? JSONEncoder().encode(LogoutRequest(refreshToken: refreshToken)) else {
            return Promise<Void>(error: NSError(domain: "sublimate.authentication.refresh", code: 900, userInfo: ["reason" : "Unable to encode body"]))
        }
        guard let base = URL(string: networkConfiguration.baseUrl) else {
            return Promise<Void>(error: NSError(domain: "sublimate.authentication.refresh", code: 900, userInfo: ["reason" : "URL was invalid "] ))
        }

        var urlRequest = URLRequest(url: base.appendingPathComponent("logout"))
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        urlRequest.httpMethod = "POST"

        return URLSession.shared.dataTask(.promise, with: urlRequest).validate()
            .map { (response : (data: Data, response: URLResponse)) -> LogoutResponse in
                return try JSONDecoder().decode(LogoutResponse.self, from: response.data)
            }
            .map({ _ in })
    }

    // MARK: Create User

    struct CreateUserResponse : Codable {
        var userId : String
    }

    struct CreateUserRequest : Codable {
        var username : String
        var password : String
    }

    func createUser(username: String, password: String) -> Promise<UserInfo> {
        guard let body = try? JSONEncoder().encode(CreateUserRequest(username: username, password: password)) else {
            return Promise<UserInfo>(error: NSError(domain: "sublimate.authentication.refresh", code: 900, userInfo: ["reason" : "Unable to encode body"]))
        }
        guard let base = URL(string: networkConfiguration.baseUrl) else {
            return Promise<UserInfo>(error: NSError(domain: "sublimate.authentication.refresh", code: 900, userInfo: ["reason" : "URL was invalid "] ))
        }

        var urlRequest = URLRequest(url: base.appendingPathComponent("createUser"))
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        urlRequest.httpMethod = "POST"

        return URLSession.shared.dataTask(.promise, with: urlRequest).validate()
            .map { (response : (data: Data, response: URLResponse)) -> CreateUserResponse in
                return try JSONDecoder().decode(CreateUserResponse.self, from: response.data)
            }
            .map({ response -> UserInfo in
                return UserInfo(username: username, userId: response.userId)
            })
    }
}
