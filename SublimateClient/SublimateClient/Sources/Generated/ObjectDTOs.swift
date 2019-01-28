// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import SublimateSync

// MARK: - DemoPrivate network dto
final class DemoPrivateDTO: Codable {
    var id : String?
    var remoteCreated : Double?
    var clientCreated : Double?
    var title: String = String.sublimateDefault()
    var content: String = String.sublimateDefault()
    var duration: Int = Int.sublimateDefault()
    var grade: Double = Double.sublimateDefault()
}
// MARK: - DemoPublic network dto
final class DemoPublicDTO: Codable {
    var id : String?
    var remoteCreated : Double?
    var clientCreated : Double?
    var name: String = String.sublimateDefault()
    var surname: String = String.sublimateDefault()
    var email: String = String.sublimateDefault()
    var age: Int = Int.sublimateDefault()
    var weight: Double = Double.sublimateDefault()
}
