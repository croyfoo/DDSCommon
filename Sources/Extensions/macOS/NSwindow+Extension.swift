//
//  File.swift
//
//  WindowManager.swift
//  SwiftUI-Mac
//
//  Created by Sarah Reichelt on 2/11/19.
//  Copyright © 2019 Sarah Reichelt. All rights reserved.
//
import SwiftUI

#if os(macOS)
extension NSWindow {
    
    public static func createStandardWindow(withTitle title: String,
                                     width: CGFloat = 800, height: CGFloat = 600,
                                     styleMask style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView] ) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: height),
            styleMask: style,
            backing: .buffered, defer: false)
        window.center()
        window.title = title
        return window
    }
    
}
#endif
