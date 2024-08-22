//
//  Int+Extension.swift
//  DDSCommon
//
//  Created by David Croy on 8/22/24.
//

public extension Int {
  var isEven: Bool {
    self % 2 == 0
  }
  
  var isOdd: Bool {
    !isEven
  }
}
