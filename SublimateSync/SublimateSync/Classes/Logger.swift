//
//  ServiceProvider.swift
//  SublimateClient
//
//  Created by i335287 on 07/11/2018.
//  Copyright © 2018 Gabriele. All rights reserved.
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


