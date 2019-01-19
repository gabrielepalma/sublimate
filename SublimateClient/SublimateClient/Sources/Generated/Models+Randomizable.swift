// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import RealmSwift
import SublimateUI

extension PeopleObject: Randomizable {
    func randomize() {
        name = String.random()
        surname = String.random()
        email = String.random()
        age = Int.random()
        weight = Double.random()
    }
}

extension SpeechesObject: Randomizable {
    func randomize() {
        title = String.random()
        content = String.random()
        duration = Int.random()
        grade = Double.random()
    }
}
