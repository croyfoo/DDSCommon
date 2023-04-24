//
//  SwiftUIView.swift
//  
//
//  Created by David Croy on 3/16/23.
// https://www.avanderlee.com/swiftui/view-composition-viewmodifiers/

import SwiftUI


extension View {
    
    /// Adds a clear button on top of the input view. The button clears the given input
    /// text binding.
    /// - Parameters:
    ///   - text: The text binding to clear when the button is tapped.
    ///   - onClearHandler: An optional clear handler that will be called on clearance.
    func clearButton(text: Binding<String>, onClearHandler: (() -> Void)?) -> some View {
        modifier(ClearTextButtonViewModifier(text: text, onClearHandler: onClearHandler))
    }
}

private struct ClearTextButtonViewModifier: ViewModifier {
    /// A binding towards the text that we'll monitor
    /// to determine whether or not we show the clear button.
    @Binding var text: String
    
    /// An optional clear handler to perform additional actions
    /// when the text is cleared.
    let onClearHandler: (() -> Void)?
    
    public func body(content: Content) -> some View {
        ZStack {
            /// References your input `Content`.
            /// Most likely the `TextField`.
            content
            
            /// The `ZStack` allows us to place this button
            /// on top of the input `Content`.
            HStack {
                Spacer()
                Button {
                    /// Clear out the text using the @Binding property.
                    text.removeAll()
                    /// Call the optional clear handler to allow
                    /// for further customization.
                    onClearHandler?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(.placeholderTextColor))
                        .padding(.trailing, 10)
                }.buttonStyle(.plain)
            }
            /// Only show the button if there's actually text input.
            .opacity(text.isEmpty ? 0.0 : 1.0)
        }
    }
}
