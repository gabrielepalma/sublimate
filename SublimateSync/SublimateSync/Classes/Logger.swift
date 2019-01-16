//
//  Logger.swift
//  SublimateSync
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import Foundation
import Swinject

struct Logger {
    public static var muted = false

    public static func log(_ string: String) {
        if !muted {
            print("\(string)")
        }
    }

    public static func error(_ string: String) {
        if !muted {
            print("🛑 \(string) 🛑")
        }
    }

    public static func warning(_ string: String) {
        if !muted {
            print("⚠️ \(string) ⚠️")
        }
    }
}


