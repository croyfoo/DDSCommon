//
//  View+.swift
//  SwiftUITests
//
//  Created by David Croy on 11/4/22.
//
import SwiftUI

extension View {

    func textPlaceHolder(alignment: Alignment = .leading, shouldShow: Bool, @ViewBuilder placeholder: @escaping () -> some View) -> some View {
        modifier(TextPlaceHolder(alignment: alignment, shouldShow: shouldShow, placeHolder: placeholder))
    }

    func textPlaceHolder(placeHolder: String, alignment: Alignment = .leading, shouldShow: Bool) -> some View {
        modifier(TextPlaceHolder(placeHolder: placeHolder, alignment: alignment, shouldShow: shouldShow))
    }
}

struct TextPlaceHolder<ContentView: View>: ViewModifier {

    var alignment: Alignment
    let shouldShow: Bool
    let placeHolder: ContentView
    
    init(alignment: Alignment, shouldShow: Bool, @ViewBuilder placeHolder: @escaping () -> ContentView) {
        self.alignment   = alignment
        self.shouldShow  = shouldShow
        self.placeHolder = placeHolder()
    }

    init(placeHolder: String, alignment: Alignment, shouldShow: Bool) where ContentView == DefaultPlaceHolderType {
        self.init(alignment: alignment, shouldShow: shouldShow) {
            DefaultPlaceHolderType(placeHolder: placeHolder)
        }
    }

    func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            placeHolder
                .opacity(shouldShow ? 1 : 0)
            content
        }
    }
}

struct DefaultPlaceHolderType: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let placeHolder: String
    
    var body: some View {
        Text(placeHolder)
            .foregroundColor(colorScheme == .dark ? .white.opacity(0.50) : .gray.opacity(0.80))
    }
}
