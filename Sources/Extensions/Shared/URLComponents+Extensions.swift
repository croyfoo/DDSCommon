//
//  URLComponents+Extensions.swift
//  Tes
//
//  Created by David Croy on 9/21/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//

import Foundation

extension URLComponents {
    mutating func addDictionaryAsQuery(_ dict: [String: String]) {
        percentEncodedQuery = dict.asQueryString
    }
}
