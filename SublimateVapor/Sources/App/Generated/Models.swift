// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import FluentSQLite
import Vapor

public func configureSublimateMigration(migrations : inout MigrationConfig) {
    migrations.add(model: People.self, database: .sqlite)
    migrations.add(model: Speeches.self, database: .sqlite)
}

// MARK: - People definition
final class People : SQLiteUUIDModel {
    var id: UUID?
    var name: String
    var surname: String
    var email: String
    var age: Int
    var weight: Double

    init(id: UUID? = nil  , name : String , surname : String , email : String , age : Int , weight : Double ) {
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        self.age = age
        self.weight = weight
    }
}

extension People: Migration { }
extension People: Content   { }
extension People: Parameter { }

// MARK: - Speeches definition
final class Speeches : SQLiteUUIDModel {
    var id: UUID?
    var owner: String?
    var title: String
    var content: String
    var duration: Int
    var grade: Double

    init(id: UUID? = nil , owner : String? = nil  , title : String , content : String , duration : Int , grade : Double ) {
        self.id = id
        self.owner = owner
        self.title = title
        self.content = content
        self.duration = duration
        self.grade = grade
    }
}

extension Speeches: Migration { }
extension Speeches: Content   { }
extension Speeches: Parameter { }
