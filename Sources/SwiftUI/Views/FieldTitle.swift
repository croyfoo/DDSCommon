//
//  FieldTitle.swift
//  SwiftUITests
//
//  Created by David Croy on 11/13/22.
//

import SwiftUI

public extension View {
    
    func fieldTitle(_ title: String, font: Font = .caption, padding: Int = 0) -> some View {
        modifier(FieldTitle(title, font: font))
    }
    
    func fieldTitle(font: Font = .caption, padding: Int = 0, @ViewBuilder titleBuilder: @escaping () -> some View) -> some View {
        modifier(FieldTitle(font: font, padding: padding, titleBuilder: titleBuilder))
    }
}

struct FieldTitle<Title:View>: ViewModifier {
    let font: Font
    let contentTitle: Title
    let padding: Int
    
    public init(_ title: String, font: Font = .caption, padding: Int = 0) where Title == Text {
        self.init(font: font, padding: padding) {
            Text(title)
        }
    }
    
    public init(font: Font = .caption, padding: Int = 0, @ViewBuilder titleBuilder: @escaping () -> Title ) {
        self.font         = font
        self.padding      = padding
        self.contentTitle = titleBuilder()
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            contentTitle
                .font(font)
                .padding(.leading, CGFloat(padding))
            content
        }
    }
}
