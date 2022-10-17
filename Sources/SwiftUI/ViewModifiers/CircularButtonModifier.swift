//
//  CircularButtonModifier.swift
//  Medo
//
//  Created by Aayush Pokharel on 2022-03-19.
//

import SwiftUI

struct CircularButtonModifier: ViewModifier {
    @State var hovering: Bool = false

    let color: Color
    let opacity: CGFloat
    let hoverOpacity: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.body.bold())
            .foregroundColor(hovering ? .white : color)
            .buttonStyle(PlainButtonStyle())
            .padding(8)
            .background(color.opacity(hovering ? 0.5 : 0.1))
            .clipShape(Circle())
            .onHover { new_value in
                withAnimation {
                    hovering = new_value
                }
            }
    }
}

public extension View {
    func circularButton(color: Color, opacity: CGFloat = 0.1, hoverOpacity: CGFloat = 0.5) -> some View {
        ModifiedContent(content: self, modifier: CircularButtonModifier(color: color, opacity: opacity,hoverOpacity: hoverOpacity))
    }
}
