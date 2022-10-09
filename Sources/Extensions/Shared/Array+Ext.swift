//
//  Array+Ext.swift
//  Tes
//
//  Created by David Croy on 7/29/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//
//https://www.hackingwithswift.com/example-code/language/how-to-find-the-difference-between-two-arrays
import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet  = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

extension Array {
    
    /// Transforms each element in the array into a Key-Value tuple.
    ///
    /// :return: New Dictionary of transformed elements.
    func mapDictionary<K, V>(_ transform: (Element) -> (K, V)) -> [K: V] {
        
        var result = [K: V]()
        
        for element in self {
            let (key, value) = transform(element)
            result[key] = value
        }
        
        return result
    }
    
    func mapDictionary<K, V>(_ transform: (Element) -> (K, V)?) -> [K: V] {
        
        var result = [K: V]()
        
        for element in self {
            if let (key, value) = transform(element) {
                result[key] = value
            }
        }
        
        return result
    }
    
    subscript(safe index: Int) -> Element? {
        
        return 0..<count ~= index ? self[index] : nil
    }
}
