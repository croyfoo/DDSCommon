//
//  File.swift
//  
//
//  Created by David Croy on 3/14/24.
//

import Foundation

// MARK: - Properties
public struct Formatters {
    static var currencyFormatter: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    static var percentFormatter: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .percent
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    static var percentFormatterFractions: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .percent
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    static var decimalFormatter: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static var decimalFormatterNoFractions: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    static var currencyFormatterFractions: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
