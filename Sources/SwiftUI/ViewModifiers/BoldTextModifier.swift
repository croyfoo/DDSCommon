//
//  BoldTextModifier.swift
//  Medo
//
//  Created by Aayush Pokharel on 2022-03-23.
//

import SwiftUI

struct BoldTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2.bold())
    }
}

public extension View {
    func boldText() -> some View {
        ModifiedContent(content: self, modifier: BoldTextModifier())
    }
}
