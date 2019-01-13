import Foundation
import Vapor
import FluentSQLite
import Authentication

final class RefreshToken: SQLiteUUIDModel {
    var id: UUID? // Only internal for database use
    var refreshToken: String // As appears in the IDClaim
    var expiresAt: Double
    var issuedToReplace: String?
    var userId: User.ID

    init(refreshToken: String, userId: User.ID, expiresAt : Double, issuedToReplace : String? = nil) {
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
        self.userId = userId
        self.issuedToReplace = issuedToReplace
    }
}

extension RefreshToken: Content   { }
extension RefreshToken: Parameter { }
extension RefreshToken: Migration {
    static func prepare(on connection: SQLiteConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.refreshToken)
        }
    }
}


