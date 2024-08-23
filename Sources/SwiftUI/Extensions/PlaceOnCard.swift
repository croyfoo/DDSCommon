//
//  PlaceOnCard.swift
//  SwiftUITests
//
//  Created by David Croy on 11/13/22.
//

import SwiftUI

//@available(macOS 12.0, *)

public extension View {
  func placeOnCard(_ style: any ShapeStyle, height: CGFloat? = nil,
                   width: CGFloat? = nil, cornerRadius: CGFloat = 10,
                   alignment: Alignment = .center,  shadow: Bool = false,
                   shadowRadius: CGFloat = 10, horizontalPadding: CGFloat = 5,
                   verticalPadding: CGFloat = 5) -> some View {
    modifier(PlacedOnCard(alignment: alignment, style: AnyShapeStyle(style),
                          height: height, width: width,  cornerRadius: cornerRadius,
                          shadow: shadow, shadowRadius: shadowRadius,
                          horizontalPadding: horizontalPadding, verticalPadding: verticalPadding))
  }
}

//@available(macOS 12.0, *)
struct PlacedOnCard: ViewModifier {
  let alignment: Alignment
  let width: CGFloat?
  let height: CGFloat?
  let cornerRadius: CGFloat
  let style: AnyShapeStyle
  let showShadow: Bool
  let shadowRadius: CGFloat
  let horizontalPadding: CGFloat
  let verticalPadding: CGFloat
  
  init(alignment: Alignment, style: AnyShapeStyle, height: CGFloat? = nil,
       width: CGFloat? = nil, cornerRadius: CGFloat, shadow: Bool, shadowRadius: CGFloat,
       horizontalPadding: CGFloat = 5, verticalPadding: CGFloat = 5) {
    self.alignment         = alignment
    self.width             = width
    self.height            = height
    self.cornerRadius      = cornerRadius
    self.style             = style
    self.showShadow        = shadow
    self.shadowRadius      = shadowRadius
    self.horizontalPadding = horizontalPadding
    self.verticalPadding   = verticalPadding
  }
  
  func body(content: Content) -> some View {
    ZStack(alignment: alignment) {
      content
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .frame(maxWidth: width, maxHeight: height, alignment: alignment)
        .background(style)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(radius: showShadow ? shadowRadius : 0)
    }
  }
}

#Preview {
  let border = true
  return VStack {
    Text("Regular Material")
      .padding()
      .placeOnCard(.regularMaterial, width: 200, shadow: border)
    Text("Thin Material")
      .padding()
      .placeOnCard(.thinMaterial, width: 200, shadow: border)
      .frame(width: 200)
    Text("Ultra thin Material")
      .padding()
      .placeOnCard(.ultraThinMaterial, width: 200, shadow: border)
    Text("Thick Material")
      .padding()
      .placeOnCard(.thickMaterial, width: 200, shadow: border)
    Text("Ultra thick Material")
      .padding()
      .placeOnCard(.ultraThickMaterial, width: 200, shadow: border)
    
    Text("Foo")
      .foregroundStyle(.secondary)
      .padding()
      .background(.ultraThinMaterial)
  }
  .padding()
  //    .background(.blue.opacity(0.1))
}
