// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import SublimateSync

// MARK: - DemoAlpha network dto
final class DemoAlphaSyncableDTO: SyncableDTO<DemoAlphaObject>, Codable {
    private var dto : DemoAlphaDTO

    override init(from object: DemoAlphaObject) {
        dto = DemoAlphaDTO()
        self.dto.text = object.text
        self.dto.count = object.count
        self.dto.id = object.remoteId
        super.init(from: object)
    }
    override func syncIdentifier() -> String? {
        return dto.id
    }

    override func update(object: DemoAlphaObject) {
        assert(object.remoteId == nil || self.dto.id == object.remoteId, "Updating an Object from a non-matching DTO")
        object.remoteId = self.dto.id
        object.text = self.dto.text
        object.count = self.dto.count
    }

    public init(from decoder: Decoder) throws {
        self.dto = try DemoAlphaDTO(from : decoder)
        super.init()
    }

    public func encode(to encoder: Encoder) throws {
        try dto.encode(to: encoder)
    }
}

// MARK: - DemoBeta network dto
final class DemoBetaSyncableDTO: SyncableDTO<DemoBetaObject>, Codable {
    private var dto : DemoBetaDTO

    override init(from object: DemoBetaObject) {
        dto = DemoBetaDTO()
        self.dto.name = object.name
        self.dto.surname = object.surname
        self.dto.id = object.remoteId
        super.init(from: object)
    }
    override func syncIdentifier() -> String? {
        return dto.id
    }

    override func update(object: DemoBetaObject) {
        assert(object.remoteId == nil || self.dto.id == object.remoteId, "Updating an Object from a non-matching DTO")
        object.remoteId = self.dto.id
        object.name = self.dto.name
        object.surname = self.dto.surname
    }

    public init(from decoder: Decoder) throws {
        self.dto = try DemoBetaDTO(from : decoder)
        super.init()
    }

    public func encode(to encoder: Encoder) throws {
        try dto.encode(to: encoder)
    }
}
