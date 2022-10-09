//
//  Date+Extension.swift
//  Tes
//
//  Created by David Croy on 12/1/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//

import Foundation

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}
