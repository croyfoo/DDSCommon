//
//  Int+Extension.swift
//  DDSCommon
//
//  Created by David Croy on 8/22/24.
//

extension Int {
  func isEven() -> Bool {
    self % 2 == 0
  }
  
  func isOdd() -> Bool {
    !isEven()
  }
}
