//
//  NetworkManager.swift
//  SublimateClient
//
//  Created by i335287 on 28/12/2018.
//  Copyright © 2018 Gabriele. All rights reserved.
//

import UIKit
import PromiseKit
import RxSwift
import Foundation

public class NetworkResponse<T> {
    public private(set) var meta: URLResponse
    public private(set) var body: T

    public init(meta: URLResponse, body: T) {
        self.meta = meta
        self.body = body
    }
}

public protocol NetworkConfigurationProtocol {
    var baseUrl : String { get }
}

public struct Request {

    public enum Method : String {
        case POST = "POST"
        case GET = "GET"
        case DELETE = "DELETE"
        case PUT = "PUT"
    }

    public enum ContentType {
        case JSON
        case MULTIPART(boundary : String)
    }

    public var id : String = UUID().uuidString
    public var method : Method
    public var contentType : ContentType
    public var additionalHeaders : [String : String]
    public var path : String
    public var body : Data?

    public init(method : Method, contentType : ContentType, path : String, body : Data? = nil, additionalHeaders : [String : String] = [:]) {
        self.method = method
        self.contentType = contentType
        self.path = path
        self.body = body
        self.additionalHeaders = additionalHeaders
    }
}

public protocol NetworkManagerProtocol {
    func makeRequest(request : Request) -> Promise<Void>
    func makeRequest<T : Codable>(request : Request, responseType: T.Type) -> Promise<T>
    func makeRequest<T : Codable>(request : Request, responseType: [T.Type]) -> Promise<[T]>
    func makeRequest(request : Request, responseType: Data.Type) -> Promise<Data>
}

public class NetworkManager : NetworkManagerProtocol {
    public var networkConfiguration : NetworkConfigurationProtocol
    public var authManager : AuthenticationManagerProtocol

    public init(networkConfiguration : NetworkConfigurationProtocol, authManager : AuthenticationManagerProtocol) {
        self.networkConfiguration = networkConfiguration
        self.authManager = authManager
    }

    public func makeRequest(request: Request) -> Promise<Void> {
        return firstly {
            makeRequestInternal(request: request)
        }.map({ r in })
    }

    public func makeRequest<T>(request: Request, responseType: T.Type) -> Promise<T> where T : Decodable, T : Encodable {
        return firstly {
            makeRequestInternal(request: request)
        }.map({ (response) -> T in
            return try JSONDecoder().decode(T.self, from: response.body)
        })
    }

    public func makeRequest<T>(request: Request, responseType: [T.Type]) -> Promise<[T]> where T : Decodable, T : Encodable {
        return firstly {
            makeRequestInternal(request: request)
        }.map({ (response) -> [T] in
            return try JSONDecoder().decode([T].self, from: response.body)
        })
    }

    public func makeRequest(request: Request, responseType: Data.Type) -> Promise<Data> {
        return firstly {
            makeRequestInternal(request: request)
        }.map({ (response) -> Data in
            return response.body
        })
    }

    private func makeRequestInternal(request : Request) -> Promise<NetworkResponse<Data>> {
        guard let base = URL(string: networkConfiguration.baseUrl) else {
            return Promise<NetworkResponse<Data>>(error: NSError(domain: "NetworkManager", code: 599, userInfo: ["reason" : "URL was invalid "] ))
        }

        let url = base.appendingPathComponent(request.path)
        var urlRequest = URLRequest(url: url)
        switch request.contentType {
        case .JSON:
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .MULTIPART(let boundary):
            urlRequest.setValue("multipart/mixed;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
        urlRequest.httpBody = request.body
        urlRequest.httpMethod = request.method.rawValue

        for header in request.additionalHeaders {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }

        for header in authManager.authorizationHeaders() {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }

        return DispatchQueue.global().async(.promise) { [authManager] () -> Promise<Void> in
                return authManager.refreshAccessTokenIfNeeded()
            }
            .tap({ [authManager] r in
                if case let Result.rejected(error) = r, let pmerror = error as? PMKHTTPError {
                    authManager.handleError(error: pmerror, duringTokenRefresh: true)
                }
            })
            .then { (_) -> Promise<(data: Data, response: URLResponse)> in
                URLSession.shared.dataTask(.promise, with: urlRequest).validate()
            }
            .tap({ [authManager] r in
                if case let Result.rejected(error) = r, let pmerror = error as? PMKHTTPError {
                    authManager.handleError(error: pmerror, duringTokenRefresh: false)
                }
            })
            .map { (response : (data: Data, response: URLResponse)) -> NetworkResponse<Data> in
                NetworkResponse(meta: response.response, body: response.data)
        }
    }
}

public class NetworkConfiguration : NetworkConfigurationProtocol {

    public init() {
    }
    
    public enum Environment : String {
        case local = "http://localhost:8080"
        case rqa = "rqa"
        case production = "production"
    }

    public var baseUrl: String {
        get {
            return environment.rawValue
        }
    }

    public var environment : Environment = .local
}
