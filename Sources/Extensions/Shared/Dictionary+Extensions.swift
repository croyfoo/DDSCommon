//
//  Dictionary+Extensions.swift
//  Tes
//
//  Created by David Croy on 9/21/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//

import Foundation

private func escapeQuery(_ query: String) -> String {
    // From RFC 3986
    let generalDelimiters = ":#[]@"
    let subDelimiters = "!$&'()*+,;="
    
    var allowedCharacters = CharacterSet.urlQueryAllowed
    allowedCharacters.remove(charactersIn: generalDelimiters + subDelimiters)
    return query.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? query
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral {
    var asQueryItems: [URLQueryItem] {
        map {
            URLQueryItem(
                name: escapeQuery(($0 as? String) ?? ""),
                value: escapeQuery(($1 as? String) ?? "")
            )
        }
    }
    
    var asQueryString: String {
        var components = URLComponents()
        components.queryItems = asQueryItems
        return components.query!
    }
}
