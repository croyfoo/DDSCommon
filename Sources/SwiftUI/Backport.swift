//
//  Backport.swift
//  Tes
//
//  Created by David Croy on 7/1/22.
//  Copyright © 2022 DoubleDog Software. All rights reserved.
//

import Foundation
import SwiftUI

public struct Backport<Content> {
    public let content: Content
    
    public init(_ content: Content) {
        self.content = content
    }
}

extension View {
    var backport: Backport<Self> { Backport(self) }
}

extension Backport where Content: View {
    @ViewBuilder func contextMenu<M, P> (
        menuItems: () -> M, preview: () -> P) -> some View where M : View , P : View {
        if #available(iOS 16, macOS 13, *) {
            content.contextMenu(menuItems: menuItems, preview: preview)
        } else {
            content.contextMenu(menuItems: menuItems)
        }
    }
}

extension Backport where Content: View {
    @ViewBuilder func badge(_ count: Int) -> some View {
        if #available(iOS 15, macOS 12, *) {
            content.badge(count)
        } else {
            content
        }
    }
}
