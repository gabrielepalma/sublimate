//
//  Type.swift
//  SublimateClient
//
//  Created by i335287 on 08/01/2019.
//  Copyright © 2019 Gabriele. All rights reserved.
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
