// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import SublimateSync

// MARK: - DemoPrivate network dto
final class DemoPrivateSyncableDTO: SyncableDTO<DemoPrivateObject>, Codable {
    private var dto : DemoPrivateDTO

    override init(from object: DemoPrivateObject) {
        dto = DemoPrivateDTO()
        self.dto.title = object.title
        self.dto.content = object.content
        self.dto.duration = object.duration
        self.dto.grade = object.grade
        self.dto.id = object.remoteId
        self.dto.remoteCreated = nil
        self.dto.clientCreated = object.clientCreated
        super.init(from: object)
    }
    override func syncIdentifier() -> String? {
        return dto.id
    }

    override func update(object: DemoPrivateObject) {
        assert(object.remoteId == nil || self.dto.id == object.remoteId, "Updating an Object from a non-matching DTO")
        object.remoteId = self.dto.id
        if let remoteCreated = self.dto.remoteCreated {
            object.remoteCreated = remoteCreated
        }
        if let clientCreated = self.dto.clientCreated {
            object.clientCreated = clientCreated
        }
        object.title = self.dto.title
        object.content = self.dto.content
        object.duration = self.dto.duration
        object.grade = self.dto.grade
    }

    public init(from decoder: Decoder) throws {
        self.dto = try DemoPrivateDTO(from : decoder)
        super.init()
    }

    public func encode(to encoder: Encoder) throws {
        try dto.encode(to: encoder)
    }
}

// MARK: - DemoPublic network dto
final class DemoPublicSyncableDTO: SyncableDTO<DemoPublicObject>, Codable {
    private var dto : DemoPublicDTO

    override init(from object: DemoPublicObject) {
        dto = DemoPublicDTO()
        self.dto.name = object.name
        self.dto.surname = object.surname
        self.dto.email = object.email
        self.dto.age = object.age
        self.dto.weight = object.weight
        self.dto.id = object.remoteId
        self.dto.remoteCreated = nil
        self.dto.clientCreated = object.clientCreated
        super.init(from: object)
    }
    override func syncIdentifier() -> String? {
        return dto.id
    }

    override func update(object: DemoPublicObject) {
        assert(object.remoteId == nil || self.dto.id == object.remoteId, "Updating an Object from a non-matching DTO")
        object.remoteId = self.dto.id
        if let remoteCreated = self.dto.remoteCreated {
            object.remoteCreated = remoteCreated
        }
        if let clientCreated = self.dto.clientCreated {
            object.clientCreated = clientCreated
        }
        object.name = self.dto.name
        object.surname = self.dto.surname
        object.email = self.dto.email
        object.age = self.dto.age
        object.weight = self.dto.weight
    }

    public init(from decoder: Decoder) throws {
        self.dto = try DemoPublicDTO(from : decoder)
        super.init()
    }

    public func encode(to encoder: Encoder) throws {
        try dto.encode(to: encoder)
    }
}
