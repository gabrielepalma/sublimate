//
//  AuthenticationManager.swift
//  SublimateClient
//
//  Created by i335287 on 05/01/2019.
//  Copyright © 2019 Gabriele. All rights reserved.
//

import UIKit
import KeychainAccess
import RxCocoa
import PromiseKit
import RxSwift

public class AuthenticationManager: AuthenticationManagerProtocol {

    public let client : AuthenticationClientProtocol
    private let keychain = Keychain(service: "sublimate")

    public init(client: AuthenticationClientProtocol) {
        self.client = client
        let refreshToken = keychain["refreshToken"]
        if refreshToken?.isEmpty ?? true {
            state = BehaviorRelay<AuthState>(value: .loggedIn)
        }
        else {
            state = BehaviorRelay<AuthState>(value: .loggedOut)
        }
    }

    private var state: BehaviorRelay<AuthState>
    public var authState: Observable<AuthState> {
        return state.asObservable()
    }

    private var refreshToken : String? {
        return keychain["refreshToken"]
    }

    private var accessToken : String? {
        return keychain["accessToken"]
    }

    public var username : String? {
        return keychain["username"]
    }

    public var userId : String? {
        return keychain["userId"]
    }

    public var isLoggedIn: Bool {
        return !(refreshToken?.isEmpty ?? true)
    }

    public func handleError(error: PMKHTTPError, duringTokenRefresh: Bool) {
        if case let PMKHTTPError.badStatusCode(code, _, _) = error,  code == 401 {
            // Access token validates but is not authorized, rare case (probably only on server side encryption key changes)
            keychain["accessToken"] = nil
        }
    }

    public func refreshAccessTokenIfNeeded() -> Promise<Void> {
        if !isLoggedIn {
            // We have nothing to refresh: skip this step but make sure user state is logged out
            state.accept(.loggedOut)
            return Promise<Void>()
        }
        if let accessToken = accessToken, JwtUtilities.isJwtTokenValid(jwtToken: accessToken) {
            // We have a valid token: no need to refresh
            return Promise<Void>()
        }
        return loginWithRefreshToken()
    }

    public func authorizationHeaders() -> [String : String] {
        guard let accessToken = accessToken else {
            return [:]
        }
        return ["Authorization" : "Bearer \(accessToken)"]
    }

    public func createUser(username: String, password: String) -> Promise<Void> {
        return client.createUser(username: username, password: password).map({ _ in () })
    }

    public func loginWithUserCredentials(username: String, password: String) -> Promise<Void> {
        return client.loginWithUserCredentials(username: username, password: password).map({ result -> Void in
            self.saveLogin(auth: result)
        })
    }

    public func loginWithRefreshToken() -> Promise<Void> {
        guard let refreshToken = refreshToken else {
            // We are not logged in!
            saveLogout()
            return Promise<Void>(error: NSError(domain: "sublimate.authentication", code: 900, userInfo: ["reason" : "Failed while refreshing token: user is logged out"]))
        }
        return client.loginWithRefreshToken(refreshToken: refreshToken)
            .tap({ [weak self] result in
                if case let Result.rejected(error) = result, case let PromiseKit.PMKHTTPError.badStatusCode(code, _, _) = error, code == 401 {
                    // Refresh token stored on device has not been authorized, we clear it out
                    self?.saveLogout()
                }
            })
            .map({ [weak self] result -> Void in
                self?.saveLogin(auth: result)
            })
    }

    public func logout() -> Promise<Void> {
        return client.logout(refreshToken: refreshToken ?? "").ensure {
            self.saveLogout()
        }
    }

    private func saveLogout() {
        keychain["username"] = nil
        keychain["userId"] = nil
        keychain["accessToken"] = nil
        keychain["refreshToken"] = nil
        state.accept(.loggedOut)
    }

    private func saveLogin(auth: Authorizations) {
        keychain["username"] = auth.0.username
        keychain["userId"] = auth.0.userId
        keychain["accessToken"] = auth.1.accessToken
        keychain["refreshToken"] = auth.1.refreshToken
        state.accept(.loggedIn)
    }
}
