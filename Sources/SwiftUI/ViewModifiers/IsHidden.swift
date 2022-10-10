//
//  SwiftUIView.swift
//  
//
//  Created by David Croy on 10/10/22.
//

import SwiftUI

struct IsHidden: ViewModifier {
    var hidden = false
    var remove = false
    
    func body(content: Content) -> some View {
        if hidden {
            if remove {
                // Remove the view
            } else {
                content.hidden()
            }
        } else {
            content
        }
    }
}

public extension View {
    func isHidden(hidden: Bool = false, remove: Bool = false) -> some View {
        modifier(IsHidden(hidden: hidden, remove: remove))
    }
}

