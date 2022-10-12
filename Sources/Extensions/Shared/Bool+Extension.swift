//
//  File.swift
//  
//
//  Created by David Croy on 10/10/22.
//

import Foundation

public extension Bool {
    static var iOS15: Bool {
        guard #available(iOS 16, *) else {
            // It's iOS 15 so return true.
            return true
        }
        // It's iOS 16 so return false.
        return false
    }

    static var macOS12: Bool {
        guard #available(macOS 13, *) else {
            // It's macOS 12 so return true.
            return true
        }
        // It's macOS 13 so return false.
        return false
    }

    static var macOS13: Bool {
        if #available(macOS 13, *) {
            // It's macOS 13 so return true.
            return true
        }
        // It's macOS < 13 so return false.
        return false
    }

    static var iOS16: Bool {
        if #available(iOS 16, *) {
            // It's iOS 16 so return true.
            return true
        }
        // It's iOS < 16 so return false.
        return false
    }
}
