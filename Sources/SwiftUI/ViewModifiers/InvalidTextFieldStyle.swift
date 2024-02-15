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
    
    public init(_ isValid: Bool = true, padding: CGFloat = .zero) {
        self.isValid       = isValid
        changeEffectValue += !isValid ? 1 : 0
        self.padding       = padding
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(padding)
            .overlay {
                if !isValid {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(isValid ? .clear : .red, lineWidth: 2)
                }
            }
        //            .changeEffect(.shake(rate: .fast), value: changeEffectValue)
    }
}
