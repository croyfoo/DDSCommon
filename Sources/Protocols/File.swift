//
//  File.swift
//  
//
//  Created by David Croy on 2/14/24.
//

import Foundation

protocol StateMachine where Self: CaseIterable & RawRepresentable & Equatable {
    var allCases: AllCases { get }
    static var allValues: [RawValue] { get }
    func next() -> Self
    func peek() -> Self
    func previous() -> Self
    func first() -> Self
    func lookBack() -> Self
    func isLast() -> Bool
    func isFirst() -> Bool
}

extension StateMachine {
    var allCases: AllCases { Self.allCases }
    
    static var allValues: [RawValue] {
        return allCases.map { $0.rawValue }
    }
    
    func next() -> Self {
        let index = allCases.firstIndex(of: self)!
        let next  = allCases.index(after: index)
        guard next != allCases.endIndex else { return allCases[index] }
        return allCases[next]
    }
    
    func peek() -> Self {
        return next()
    }
    
    func lookBack() -> Self {
        return previous()
    }
    
    func previous() -> Self {
        let index    = allCases.firstIndex(of: self)!
        let previous = allCases.index(index, offsetBy: -1)
        guard previous >= allCases.startIndex else { return allCases[index] }
        return allCases[previous]
    }
    
    func first() -> Self {
        allCases[allCases.startIndex]
    }
    
    func isLast() -> Bool {
        allCases.firstIndex(of: self)! == allCases.index(allCases.endIndex, offsetBy: -1)
    }
    
    func isFirst() -> Bool {
        allCases.firstIndex(of: self)! == allCases.index(allCases.startIndex, offsetBy: 0)
    }
}

