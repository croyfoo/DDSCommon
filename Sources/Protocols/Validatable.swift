//
//  File.swift
//  
//
//  Created by David Croy on 5/29/24.
//

import Foundation

public protocol Validatable {}

extension Validatable {
  public func validValue(_ value: Int?) -> Bool {
    guard let value else { return false }
    return value > 0
  }
  
  public func validLength(_ value: Int?, length: Int) -> Bool {
    guard validValue(value) else { return false }
    return String(value ?? 0).count == length
  }
  
  public func validValue(_ value: Double?) -> Bool {
    guard let value else { return false }
    return value > 0.0
  }
  
  public func validValue(_ value: Float?) -> Bool {
    guard let value else { return false }
    return value > 0.0
  }
  
  public func validValue(_ value: String?) -> Bool {
    guard let value else { return false }
    return value.count > 0
  }
  
  public func validValueZero(_ value: Double?) -> Bool {
    guard let value else { return false }
    return value >= 0.0
  }
  
  public func validValueZero(_ value: Float?) -> Bool {
    guard let value else { return false }
    return value >= 0.0
  }
  
  public func validateDate(_ value: String?, format: String = "MM/dd/yyyy") -> Bool {
    guard validValue(value) else { return false }
    
    let dateFormatter        = DateFormatter()
    dateFormatter.dateFormat = format
    
    guard let value = value, value.length == 10 else { return false }
    guard dateFormatter.date(from: value) != nil else { return false }
    
    return true
  }
}

public enum ValidationError<V : RawRepresentable>: Error {
  case isEmpty(V)
  case invalidFormat(V, String? = nil)
  case invalidLength(V, Int)
  case customMessage(V, String)
  case notChecked(V)
  
  public var message: String {
    switch self {
      case .isEmpty(let field):
        return "\(field.rawValue) must not be blank"
      case .invalidFormat(let field, let format):
        return format != nil ? "\(field.rawValue) must be in \(format!) format" : "\(field.rawValue) is an invalid format"
      case .invalidLength(let field, let length):
        return "\(field.rawValue) must be \(length) digits"
      case .notChecked(let field):
        return "\(field.rawValue) must be checked"
      case .customMessage(_, let message):
        return message
    }
  }
  
  public var field: V {
    switch self {
      case .isEmpty(let field):
        return field
      case .invalidFormat(let field, _):
        return field
      case .invalidLength(let field, _):
        return field
      case .notChecked(let field):
        return field
      case .customMessage(let field, _):
        return field
    }
  }
}

