//
//  Collection.swift
//  ControlRoom
//
//  Created by Dave DeLong on 2/15/20.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import Foundation

public extension Collection {
    var isNotEmpty: Bool { isEmpty == false }
}

/// https://tanaschita.com/swift-basics-safe-array-subscription/?utm_source=swiftlee&utm_medium=swiftlee_weekly&utm_campaign=issue_212
extension Collection {
    /// Returns the element at the specified index if it exists, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
