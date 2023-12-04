//
//  FieldTitle.swift
//  SwiftUITests
//
//  Created by David Croy on 11/13/22.
//

import SwiftUI

public enum TitlePosition {
    case top, leading
}

public extension View {
    
    func fieldTitle(_ title: String, font: Font = .caption, padding: Int = 0, titlePosition: TitlePosition = .top) -> some View {
        modifier(FieldTitle(title, font: font, titlePosition: titlePosition))
    }
    
    func fieldTitle(font: Font = .caption, padding: Int = 0, titlePosition: TitlePosition = .top, @ViewBuilder titleBuilder: @escaping () -> some View) -> some View {
        modifier(FieldTitle(font: font, padding: padding, titlePosition: titlePosition, titleBuilder: titleBuilder))
    }
}

struct FieldTitle<Title:View>: ViewModifier {
    let font: Font
    let contentTitle: Title
    let padding: Int
    let titlePosition: TitlePosition
    let width: CGFloat?
    
    public init(_ title: String, font: Font = .caption, padding: Int = 0, titlePosition: TitlePosition = .top,
                titleWidth: CGFloat? = nil) where Title == Text {
        self.init(font: font, padding: padding, titlePosition: titlePosition, titleWidth: titleWidth) {
            Text(title)
        }
    }
    
    public init(font: Font = .caption, padding: Int = 0, titlePosition: TitlePosition = .top, titleWidth: CGFloat? = nil,
                @ViewBuilder titleBuilder: @escaping () -> Title ) {
        self.font          = font
        self.padding       = padding
        self.contentTitle  = titleBuilder()
        self.titlePosition = titlePosition
        self.width          = titleWidth
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            if titlePosition == .top {
                contentTitle
                    .font(font)
                    .padding(.leading, CGFloat(padding))
                    .frame(width: width)
                content
            } else {
                HStack {
                    contentTitle
                        .font(font)
                        .padding(.trailing, CGFloat(padding))
                        .frame(width: width)
                    content
                }
            }
        }
    }
}
