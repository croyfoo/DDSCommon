//
//  NSColor+Ext.swift
//  Tes
//
//  Created by David Croy on 7/23/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit

public extension NSColor {
    
    func lighter(_ amount: CGFloat = 0.25) -> NSColor {
        return hueColorWithBrightnessAmount(1 + amount)
    }
    
    func darker(_ amount: CGFloat = 0.25) -> NSColor {
        return hueColorWithBrightnessAmount(1 - amount)
    }
    
    private func hueColorWithBrightnessAmount(_ amount: CGFloat) -> NSColor {
        var hue: CGFloat        = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat      = 0
        let color               =     usingColorSpace(NSColorSpace.genericRGB)

        #if os(iOS)
        if color?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return PXColor( hue: hue,
                            saturation: saturation,
                            brightness: brightness * amount,
                            alpha: alpha )
        } else {
            return self
        }
        
        #else
        
        color?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return NSColor( hue: hue,
                        saturation: saturation,
                        brightness: brightness * amount,
                        alpha: alpha )
        
        #endif
        
    }
}
#endif
