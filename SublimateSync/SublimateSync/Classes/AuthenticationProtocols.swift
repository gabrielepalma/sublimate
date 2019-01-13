//
//  AuthViewController.swift
//  SublimateClient
//
//  Created by i335287 on 12/01/2019.
//  Copyright © 2019 Gabriele. All rights reserved.
//

import UIKit
import KeychainAccess
import RxCocoa
import PromiseKit
import RxSwift

public enum AuthState {
    case loggedIn
    case loggedOut
}

public typealias Authorizations = (UserInfo, TokenInfo)

public struct UserInfo {
    var username: String
    var userId: String
    public init(username: String, userId: String) {
        self.username = username
        self.userId = userId
    }
}

public struct TokenInfo {
    var accessToken: String
    var refreshToken: String
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public protocol AuthenticationClientProtocol {
    func createUser(username : String, password : String) -> Promise<UserInfo>
    func loginWithUserCredentials(username : String, password : String) -> Promise<Authorizations>
    func loginWithRefreshToken(refreshToken : String) -> Promise<Authorizations>
    func logout(refreshToken : String) -> Promise<Void>
}

public protocol AuthenticationManagerProtocol {
    func createUser(username : String, password : String) -> Promise<Void>
    func loginWithUserCredentials(username : String, password : String) -> Promise<Void>
    func loginWithRefreshToken() -> Promise<Void>
    func logout() -> Promise<Void>

    var username : String? { get }
    var userId : String? { get }
    var isLoggedIn: Bool { get }
    var authState : Observable<AuthState> { get }

    func refreshAccessTokenIfNeeded() -> Promise<Void>
    func authorizationHeaders() -> [String : String]
    func handleError(error : PMKHTTPError, duringTokenRefresh: Bool)
}
