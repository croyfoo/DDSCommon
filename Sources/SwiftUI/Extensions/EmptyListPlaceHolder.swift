//
//  SwiftUIView.swift
//  
//
//  Created by David Croy on 1/11/23.
// https://medium.com/@kwylez/swiftui-custom-viewmodifier-for-empty-lists-634de5a4d375

import SwiftUI


extension View {
    func emptyListPlaceHolder<V: Collection, Content: View>(_ data: Binding<V>, @ViewBuilder placeHolderContent: @escaping () -> Content) -> some View {
        return self.modifier(EmptyListPlaceHolderViewModifier(data: data, placeHolderContent: placeHolderContent))
    }
}

struct EmptyListPlaceHolderViewModifier<V: Collection, P: View>: ViewModifier {
    @Binding
    var data: V
    
    @ViewBuilder
    var placeHolderContent: () -> P
    
    func body(content: Content) -> some View {
        if !data.isEmpty {
            content
        } else {
            placeHolderContent()
        }
    }
}
