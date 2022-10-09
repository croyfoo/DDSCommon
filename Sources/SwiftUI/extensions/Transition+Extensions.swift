//
//  Transision+Extensions.swift
//  Tes
//
//  Created by David Croy on 6/5/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//

import SwiftUI

public extension AnyTransition {
    static var pageTransitionNext: AnyTransition {
        let removal = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var pageTransitionPrev: AnyTransition {
        let removal = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let insertion = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var slideOutFromLeft: AnyTransition {
        AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
    }

    static var slideOutFromRight: AnyTransition {
        AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
    }

    static var slideOutFromTop: AnyTransition {
        AnyTransition.move(edge: .top)
            .combined(with: .opacity)
    }

    static var slideOutFromBottom: AnyTransition {
        AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
    }
}
