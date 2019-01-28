// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import FluentSQLite
import Vapor

public func configureSublimateMigration(migrations : inout MigrationConfig) {
    migrations.add(model: DemoPrivate.self, database: .sqlite)
    migrations.add(model: DemoPublic.self, database: .sqlite)
}

// MARK: - DemoPrivate definition
final class DemoPrivate : SQLiteUUIDModel {
    var id: UUID?
    var remoteCreated: Double?
    var clientCreated: Double
    var owner: String?
    var title: String
    var content: String
    var duration: Int
    var grade: Double

init(id: UUID? = nil, clientCreated: Double, owner : String? = nil  , title : String , content : String , duration : Int , grade : Double ) {
        self.id = id
        self.clientCreated = clientCreated
        self.owner = owner
        self.title = title
        self.content = content
        self.duration = duration
        self.grade = grade
    }
}

extension DemoPrivate: Migration { }
extension DemoPrivate: Content   { }
extension DemoPrivate: Parameter { }

// MARK: - DemoPublic definition
final class DemoPublic : SQLiteUUIDModel {
    var id: UUID?
    var remoteCreated: Double?
    var clientCreated: Double
    var name: String
    var surname: String
    var email: String
    var age: Int
    var weight: Double

init(id: UUID? = nil, clientCreated: Double , name : String , surname : String , email : String , age : Int , weight : Double ) {
        self.id = id
        self.clientCreated = clientCreated
        self.name = name
        self.surname = surname
        self.email = email
        self.age = age
        self.weight = weight
    }
}

extension DemoPublic: Migration { }
extension DemoPublic: Content   { }
extension DemoPublic: Parameter { }
