//
//  FieldTitle.swift
//  SwiftUITests
//
//  Created by David Croy on 11/13/22.
//

import SwiftUI

public enum TitlePosition {
    case top, leading, none
}

public extension View {
    
    func fieldTitle(_ title: String, font: Font? = nil, padding: CGFloat = .zero, position: TitlePosition = .top,
                    width: CGFloat? = nil, alignment: Alignment = .leading, lineLimit: Int? = 1) -> some View {
        modifier(FieldTitle(title, font: font, position: position, width: width, alignment: alignment, lineLimit: lineLimit))
    }
    
    func fieldTitle(font: Font? = nil, padding: CGFloat = .zero, position: TitlePosition = .top, width: CGFloat? = nil,
                    alignment: Alignment = .leading, lineLimit: Int? = 1, @ViewBuilder titleBuilder: @escaping () -> some View) -> some View {
        modifier(FieldTitle(font: font, padding: padding, position: position, width: width,
                            alignment: alignment, lineLimit: lineLimit, titleBuilder: titleBuilder))
    }
}

struct FieldTitle<Title:View>: ViewModifier {
    let font: Font?
    let contentTitle: Title
    let padding: CGFloat
    let position: TitlePosition
    let width: CGFloat?
    let alignment: Alignment
    let lineLimit: Int?
    
    public init(_ title: String, font: Font? = nil, padding: CGFloat = .zero, position: TitlePosition = .top,
                width: CGFloat? = nil, alignment: Alignment = .leading, lineLimit: Int? = nil) where Title == Text {
        self.init(font: font, padding: padding, position: position, width: width, lineLimit: lineLimit) {
            Text(title)
        }
    }
    
    public init(font: Font? = nil, padding: CGFloat = .zero, position: TitlePosition = .top, width: CGFloat? = nil,
                alignment: Alignment = .leading, lineLimit: Int? = nil, @ViewBuilder titleBuilder: @escaping () -> Title ) {
        self.font          = font
        self.padding       = padding
        self.contentTitle  = titleBuilder()
        self.position      = position
        self.width         = width
        self.alignment     = alignment
        self.lineLimit     = lineLimit
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            if position == .top {
                title()
                content
            } else {
                HStack {
                    title()
                    content
                }
            }
        }
    }
    
    @ViewBuilder
    private func title() -> some View {
        contentTitle
            .font(font)
            .padding(.trailing, padding)
            .frame(width: width, alignment: alignment)
//            .lineLimit(1)
//            .minimumScaleFactor(0.1)
            .lineLimit(lineLimit)
            .minimumScaleFactor(lineLimit != nil ? 0.2 : 0.0)
    }
}
