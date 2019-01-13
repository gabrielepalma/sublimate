// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import RealmSwift
import SublimateUI

extension DemoAlphaObject: Randomizable {
    func randomize() {
        text = String.random()
        count = Int.random()
    }
}

extension DemoBetaObject: Randomizable {
    func randomize() {
        name = String.random()
        surname = String.random()
    }
}
