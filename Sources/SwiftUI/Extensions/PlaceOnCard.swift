//
//  PlaceOnCard.swift
//  SwiftUITests
//
//  Created by David Croy on 11/13/22.
//

import SwiftUI

@available(macOS 12.0, *)

public extension View {
    func placeOnCard(_ style: any ShapeStyle, height: CGFloat? = nil,
                     width: CGFloat? = nil, cornerRadius: CGFloat = 10,
                     alignment: Alignment = .center,  shadow: Bool = false,
                     shadowRadius: CGFloat = 10) -> some View {
        modifier(PlacedOnCard(alignment: alignment, style: AnyShapeStyle(style),
                              height: height, width: width,  cornerRadius: cornerRadius,
                              shadow: shadow, shadowRadius: shadowRadius))
    }
}

@available(macOS 12.0, *)
struct PlacedOnCard: ViewModifier {
    let alignment: Alignment
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    let style: AnyShapeStyle
    let showShadow: Bool
    let shadowRadius: CGFloat
    
    init(alignment: Alignment, style: AnyShapeStyle, height: CGFloat? = nil,
         width: CGFloat? = nil, cornerRadius: CGFloat, shadow: Bool, shadowRadius: CGFloat) {
        self.alignment    = alignment
        self.width        = width
        self.height       = height
        self.cornerRadius = cornerRadius
        self.style        = style
        self.showShadow   = shadow
        self.shadowRadius = shadowRadius
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            content
                .padding(5)
                .frame(width: width, height: height, alignment: alignment)
                .background(style)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .shadow(radius: showShadow ? shadowRadius : 0)
            //                .background(RoundedRectangle(cornerRadius: cornerRadius).foregroundColor(.blue))
        }
    }
}

