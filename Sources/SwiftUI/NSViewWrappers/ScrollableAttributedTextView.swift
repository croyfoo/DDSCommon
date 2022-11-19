//
//  ScrollableAttributedView.swift
//  Tes
//
//  Created by David Croy on 7/23/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//
// swiftlint:disable force_cast

import SwiftUI

#if os(macOS)
struct ScrollableAttributedTextView: NSViewRepresentable {
    
    typealias NSViewType = NSScrollView
    
    var attributedText: NSAttributedString?
    var font: NSFont?
    var borderType      = NSBorderType.bezelBorder
    var drawsBackground = true
    var isEditable      = false
    
    func makeNSView(context: Context) -> NSViewType {
        let scrollView = NSTextView.scrollableTextView()
        //        scrollView.borderType = .bezelBorder
        //        scrollView.drawsBackground = false
        
        let textView = scrollView.documentView as! NSTextView
//        textView.isAutomaticDataDetectionEnabled = true
        textView.displaysLinkToolTips = true
//        textView.textColor = .labelColor
//        textView.backgroundColor = .textBackgroundColor
        textView.drawsBackground = false
        textView.isSelectable    = true
        //        textView.textContainerInset = CGSize(width: 5, height: 10)
        //        textView.textColor = .controlTextColor
        textView.isAutomaticDataDetectionEnabled = true
        textView.wantsLayer                      = true
        if context.environment.colorScheme == .dark {
            //            logger.debug("Dark Mode")
//            textView.layer?.backgroundColor = NSColor.textBackgroundColor.lighter(3.50).cgColor
        }
        return scrollView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.borderType      = borderType
        nsView.drawsBackground = drawsBackground
        
        let textView        = (nsView.documentView as! NSTextView)
        textView.isEditable = isEditable
        nsView.resignFirstResponder()
        
        if let attributedText,
           attributedText != textView.attributedString() {
            //            let foo = attributedText.attribute(.foregroundColor, at: 0, effectiveRange: nil)
            textView.textStorage?.setAttributedString(attributedText)
        }
        
        if let font {
            textView.font = font
        }
        
        if let lineLimit = context.environment.lineLimit {
            textView.textContainer?.maximumNumberOfLines = lineLimit
        }
    }
}

#endif

