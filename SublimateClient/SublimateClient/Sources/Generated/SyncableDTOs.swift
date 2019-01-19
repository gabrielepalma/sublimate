// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import SublimateSync

// MARK: - People network dto
final class PeopleSyncableDTO: SyncableDTO<PeopleObject>, Codable {
    private var dto : PeopleDTO

    override init(from object: PeopleObject) {
        dto = PeopleDTO()
        self.dto.name = object.name
        self.dto.surname = object.surname
        self.dto.email = object.email
        self.dto.age = object.age
        self.dto.weight = object.weight
        self.dto.id = object.remoteId
        super.init(from: object)
    }
    override func syncIdentifier() -> String? {
        return dto.id
    }

    override func update(object: PeopleObject) {
        assert(object.remoteId == nil || self.dto.id == object.remoteId, "Updating an Object from a non-matching DTO")
        object.remoteId = self.dto.id
        object.name = self.dto.name
        object.surname = self.dto.surname
        object.email = self.dto.email
        object.age = self.dto.age
        object.weight = self.dto.weight
    }

    public init(from decoder: Decoder) throws {
        self.dto = try PeopleDTO(from : decoder)
        super.init()
    }

    public func encode(to encoder: Encoder) throws {
        try dto.encode(to: encoder)
    }
}

// MARK: - Speeches network dto
final class SpeechesSyncableDTO: SyncableDTO<SpeechesObject>, Codable {
    private var dto : SpeechesDTO

    override init(from object: SpeechesObject) {
        dto = SpeechesDTO()
        self.dto.title = object.title
        self.dto.content = object.content
        self.dto.duration = object.duration
        self.dto.grade = object.grade
        self.dto.id = object.remoteId
        super.init(from: object)
    }
    override func syncIdentifier() -> String? {
        return dto.id
    }

    override func update(object: SpeechesObject) {
        assert(object.remoteId == nil || self.dto.id == object.remoteId, "Updating an Object from a non-matching DTO")
        object.remoteId = self.dto.id
        object.title = self.dto.title
        object.content = self.dto.content
        object.duration = self.dto.duration
        object.grade = self.dto.grade
    }

    public init(from decoder: Decoder) throws {
        self.dto = try SpeechesDTO(from : decoder)
        super.init()
    }

    public func encode(to encoder: Encoder) throws {
        try dto.encode(to: encoder)
    }
}
