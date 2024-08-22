//
//  VerticalDivider.swift
//  DDSCommon
//
//  Created by David Croy on 8/22/24.
//

import SwiftUI

struct VerticalDivider: View {
  
  let height: CGFloat
  let width: CGFloat
  let foregroundStyle: AnyShapeStyle
  
  init(height: CGFloat = 30, width: CGFloat = 1, foregroundStyle: any ShapeStyle = .tertiary) {
    self.height          = height
    self.width           = width
    self.foregroundStyle = AnyShapeStyle(foregroundStyle)
  }
  
  var body: some View {
    Rectangle()
      .frame(width: width, height: height)
      .foregroundStyle(foregroundStyle)
  }
}


