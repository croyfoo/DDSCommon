//
//  Array+Ext.swift
//  Tes
//
//  Created by David Croy on 7/29/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//
import Foundation

public extension Array where Element == Double {
  func percentile95() -> Double? {
    guard !self.isEmpty else { return nil }

    let sortedArray = self.sorted()
    let index       = Int(Double(sortedArray.count) * 0.95)
    
    // Ensure the index is within bounds
    let percentileIndex = Swift.min(index, sortedArray.count - 1)
    
    return sortedArray[percentileIndex]
  }
}

public extension Array where Element == Double {
  func percentile(of value: Double) -> Double? {
    guard self.isNotEmpty else { return nil }

    // Step 1: Sort the array in ascending order
    let sortedArray = sorted()
    
    // Step 2: Find the index of the given value
    guard let index = sortedArray.firstIndex(where: { $0 >= value } ) else {
      return nil // Value not found
    }
    
    // Step 3: Calculate the percentile
    let rank       = Double(index + 1) // Convert index to 1-based rank
    let percentile = (rank / Double(sortedArray.count)) * 100
    
    return percentile
  }
}

/// https://www.hackingwithswift.com/example-code/language/how-to-find-the-difference-between-two-arrays
public extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet  = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

public extension Array {
    
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
        0..<count ~= index ? self[index] : nil
    }
}
