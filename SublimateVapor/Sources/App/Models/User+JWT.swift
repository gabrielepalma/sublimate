//
//  USerViewController.swift
//  App
//
//  Created by i335287 on 12/01/2019.
//

import JWT
import Vapor

extension User {
    func createJwt(usage : String, expiration : Double) throws -> (String,  SublimateJwt.Payload) {
        if let id = self.id?.uuidString {
            let now = Date().timeIntervalSince1970
            let exp = Date().timeIntervalSince1970 + expiration
            let payLoad =  SublimateJwt.Payload(userId: id, usage: usage, iat: now, exp: exp)
            let jwt = JWT(header: SublimateJwt.headers(kid: SublimateJwt.kids[0]), payload: payLoad)
            let data = try jwt.sign(using: SublimateJwt.signers)
            if let token = String(data: data, encoding: .utf8) {
                return (token, payLoad)
            }
            else {
                throw JWTError(identifier: "JWT", reason: "Error while creating JWT: Serializing data")
            }
        }
        else {
            throw JWTError(identifier: "JWT", reason: "Error while creating JWT: User ID was nil")
        }
    }
}
