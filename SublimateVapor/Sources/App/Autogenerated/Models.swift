// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import FluentSQLite
import Vapor

public func configureSublimateMigration(migrations : inout MigrationConfig) {
    migrations.add(model: DemoAlpha.self, database: .sqlite)
    migrations.add(model: DemoBeta.self, database: .sqlite)
}

// MARK: - DemoAlpha definition
final class DemoAlpha : SQLiteUUIDModel {
    var id: UUID?
    var text: String
    var count: Int

    init(id: UUID? = nil  , text : String , count : Int ) {
        self.id = id
        self.text = text
        self.count = count
    }
}

extension DemoAlpha: Migration { }
extension DemoAlpha: Content   { }
extension DemoAlpha: Parameter { }

// MARK: - DemoBeta definition
final class DemoBeta : SQLiteUUIDModel {
    var id: UUID?
    var owner: String?
    var name: String
    var surname: String

    init(id: UUID? = nil , owner : String? = nil  , name : String , surname : String ) {
        self.id = id
        self.owner = owner
        self.name = name
        self.surname = surname
    }
}

extension DemoBeta: Migration { }
extension DemoBeta: Content   { }
extension DemoBeta: Parameter { }
