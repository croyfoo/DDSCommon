//
//  View+Extensions.swift
//  FoldingText
//
//  Created by David Croy on 3/26/22.
//

import AppKit
import SwiftUI

public extension View {
    func transparentBox(_ opacity: Double = 0.2, cornerRadius: CGFloat = 10, alignment: Alignment = .leading, maxWidth: CGFloat = .infinity) -> some View {
        self
//            .padding()
            .frame(maxWidth: maxWidth, alignment: alignment)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.windowBackgroundColor).opacity(opacity))
            )
    }
    
    func transparentBoxWithShadow(_ opacity: Double = 0.2, cornerRadius: CGFloat = 10, shadowRadius: CGFloat = 10) -> some View {
        self
//            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.windowBackgroundColor).opacity(opacity))
            )
            .clipped()
            .shadow(radius: shadowRadius)
    }
}

extension View {
    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
}
