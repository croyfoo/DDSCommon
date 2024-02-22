//
//  SwiftUIView.swift
//  
//
//  Created by David Croy on 2/15/24.
//

import SwiftUI

public struct InvalidTextFieldStyle: TextFieldStyle {
    private var isValid           = false
    private var changeEffectValue = 0
    private var padding: CGFloat
    private var edges: [Edge]
    private let allEdges: [Edge] = [.trailing, .leading, .bottom, .top]

    public init(_ isValid: Bool = true, padding: CGFloat = .zero, edges: Edge...) {
        self.isValid       = isValid
        changeEffectValue += !isValid ? 1 : 0
        self.padding       = padding
        self.edges         = edges.isEmpty ? [.trailing, .leading, .bottom, .top] : edges
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(padding)
            .overlay {
                if !isValid {
                    if edges == allEdges {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(.red, lineWidth: 2)
                    } else {
                        EdgeBorder(width: 2, edges: edges)
                            .foregroundColor(.red)
                    }
                }
            }
    }
}
