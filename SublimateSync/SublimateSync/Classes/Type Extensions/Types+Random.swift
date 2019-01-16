//
//  Types+Random.swift
//  SublimateSync
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import UIKit

public extension Int {

    public static func random() -> Int {
        return Int.random(n: Int(UInt32.max))
    }

    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }

    public static func random(min: Int, max: Int) -> Int {
        return Int.random(n: max - min + 1) + min

    }
}

public extension Double {

    public static func random() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }

    public static func random(min: Double, max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}

extension String {
    public static func random() -> String {
        let type = Int.random(n: 4)
        switch type {
        case 0:
            return Lorem.words(3)
        case 1:
            return Lorem.fullName
        case 2:
            return Lorem.emailAddress
        case 3:
            return Lorem.url
        default:
            return ""
        }
    }
}

