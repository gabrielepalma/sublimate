// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import SublimateSync

// MARK: - DemoAlpha network dto
final class DemoAlphaDTO: Codable {
    var id : String?
    var text: String = String.sublimateDefault()
    var count: Int = Int.sublimateDefault()
}
// MARK: - DemoBeta network dto
final class DemoBetaDTO: Codable {
    var id : String?
    var name: String = String.sublimateDefault()
    var surname: String = String.sublimateDefault()
}
