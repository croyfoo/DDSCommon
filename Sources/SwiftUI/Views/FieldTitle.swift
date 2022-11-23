//
//  FieldTitle.swift
//  SwiftUITests
//
//  Created by David Croy on 11/13/22.
//

import SwiftUI

extension View {
    
    func fieldTitle(_ title: String, font: Font = .caption) -> some View {
        modifier(FieldTitle(title, font: font))
    }
    
    func fieldTitle(font: Font = .caption, @ViewBuilder titleBuilder: @escaping () -> some View) -> some View {
        modifier(FieldTitle(font: font, titleBuilder: titleBuilder))
    }
}

struct FieldTitle<Title:View>: ViewModifier {
    let font: Font
    let contentTitle: Title
    
    public init(_ title: String, font: Font = .caption) where Title == Text {
        self.init(font: font) {
            Text(title)
        }
    }
    
    public init(font: Font = .caption, @ViewBuilder titleBuilder: @escaping () -> Title ) {
        self.font         = font
        self.contentTitle = titleBuilder()
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            contentTitle
                .font(font)
                .padding(.leading, 15)
            content
        }
    }
}
