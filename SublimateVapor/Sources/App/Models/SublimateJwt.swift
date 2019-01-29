//
//  jwt.swift
//  App
//
//  Created by i335287 on 03/01/2019.
//

import JWT
import Vapor

struct SublimateJwt {
    static let symmetricKey = "mySymmetricKey"
    static let issuerClaim = "sublimate"
    static var signers = SublimateJwt.signers(kids: kids)
    static let kids = [
        Kid(name: "symm", alg: "H256", signer: JWTSigner.hs256(key: Data(symmetricKey.utf8)))
    ]

    struct AccessToken {
        //        static let expiration : Double = 60 * 20 // 20 minutes
        static let expiration : Double = 60 // 20 minutes
        static let usage = "access_token"
    }

    struct RefreshToken {
        static let expiration : Double = 60 * 60 * 24 * 256 // One year
        static let usage = "refresh_token"
    }

    static func headers(kid : Kid) -> JWTHeader {
        return JWTHeader(alg: kid.alg, typ: "JWT", cty: nil, crit: nil, kid: kid.name)
    }

    static func signers(kids : [Kid]) -> JWTSigners {
        let signers = JWTSigners()
        for i in kids {
            signers.use(i.signer, kid: i.name)
        }
        return signers
    }

    struct Payload: JWTPayload {
        var userId: String
        var isAdmin: Bool
        var tokenId: IDClaim
        var usage: String
        var iat: IssuedAtClaim
        var exp: ExpirationClaim
        var iss: IssuerClaim = IssuerClaim(value: SublimateJwt.issuerClaim)

        func verify(using signer: JWTSigner) throws {
            try exp.verifyNotExpired()
        }

        init(userId: String, isAdmin: Bool, usage: String, iat: Double, exp: Double, tokenId: String = UUID().uuidString) {
            self.userId = userId
            self.usage = usage
            self.iat = IssuedAtClaim(value: Date(timeIntervalSince1970: iat))
            self.exp = ExpirationClaim(value: Date(timeIntervalSince1970: exp))
            self.tokenId = IDClaim(value: tokenId)
            self.isAdmin = isAdmin
        }
    }

    struct Kid {
        let name : String
        let alg : String
        let signer : JWTSigner
    }
}
