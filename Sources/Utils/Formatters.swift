//
//  File.swift
//
//
//  Created by David Croy on 3/14/24.
//

import Foundation

// MARK: - Properties
public struct Formatters {
    public static var currencyFormatter: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    public static var percentFormatter: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .percent
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    public static var percentFormatterFractions: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .percent
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    public static var decimalFormatter: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    public static var decimalFormatterNoFractions: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    public static var currencyFormatterFractions: NumberFormatter = {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

public extension Formatters {
    static func currency(_ value: Float?, fractions: Int = 0) -> String {
        Self.currency(Double(value ?? 0.0), fractions: fractions)
    }
    
    static func currency(_ value: Double?, fractions: Int = 0) -> String {
        let formatter = Self.currencyFormatter
        formatter.maximumFractionDigits = fractions
        
        return formatter.string(for: value ?? 0) ?? ""
    }
    
    static func percent(_ value: Float, fractions: Int = 0) -> String {
        Self.percent(Double(value), fractions: fractions)
    }
    
    static func percent(_ value: Double?, fractions: Int = 0) -> String {
        let formatter = Self.percentFormatter
        formatter.maximumFractionDigits = fractions
        return formatter.string(for: value ?? 0) ?? ""
    }
    
    static func decimal(_ value: Double?, fractions: Int = 2) -> String {
        let formatter = Self.decimalFormatter
        formatter.maximumFractionDigits = fractions
        return formatter.string(for: value ?? 0) ?? ""
    }
    
    static func localizedYear(_ years: Int) -> AttributedString {
        AttributedString(localized: String.LocalizationValue("^[\(years) year](inflect: true)"))
    }
    
    static func localizedMonth(_ months: Int) -> AttributedString {
        AttributedString(localized: String.LocalizationValue("^[\(months) month](inflect: true)"))
    }
    
    static func todayAsString() -> String {
        let currentDate = Date()
        let calendar    = Calendar.current
        let today        = String(format: "%02d/%02d/%04d", calendar.component(.month, from: currentDate),
                                  calendar.component(.day, from: currentDate), calendar.component(.year, from: currentDate))
        return today
    }
}
