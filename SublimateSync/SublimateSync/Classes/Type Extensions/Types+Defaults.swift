//
//  Types+Defaults.swift
//  SublimateSync
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import UIKit

extension Double {
    @inline(__always) static public func sublimateDefault() -> Double {
        return 0.0
    }
}

extension String {
    @inline(__always) static public func sublimateDefault() -> String {
        return ""
    }
}

extension Int {
    @inline(__always) static public func sublimateDefault() -> Int {
        return 0
    }
}
