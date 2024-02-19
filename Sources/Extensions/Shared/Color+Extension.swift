//
//  Color+Extension.swift
//  Tes
//
//  Created by David Croy on 6/5/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//

import SwiftUI

public extension Color {
    
#if os(macOS)
    static let backgroundColor     = Color(.windowBackgroundColor)
    static let secondaryBackground = Color(.underPageBackgroundColor)
    static let tertiaryBackground  = Color(.controlBackgroundColor)
    static let textBackground      = Color(.textBackgroundColor)
    #else
    static let backgroundColor     = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground  = Color(.tertiarySystemBackground)
    #endif
    
    static let normal       = Color(white: 0.0, opacity: 0.0) // 0
    static let darkHover    = Color(white: 1.0, opacity: 0.25)// 1
    static let darkClicked  = Color(white: 1.0, opacity: 0.4) // 2
    static let lightHover   = Color(white: 0.0, opacity: 0.25) //7
    static let lightClicked = Color(white: 0.0, opacity: 0.6) //8

    static let foregroundNormal     = Color(white: 0.75, opacity: 1.0) //4
    static let foregroundDarkHover  = Color(white: 1.0, opacity: 1.0) //5
    static let foregroundLightHover = Color(white: 0.2, opacity: 1.0) //6
}
