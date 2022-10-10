//
//  ScrollableTextView.swift
//  Tes
//
//  Created by David Croy on 7/23/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//
// swiftlint:disable force_cast

import SwiftUI

/**
 A scrollable and and optionally editable text view.
 
 - Note: This exist as the SwiftUI `TextField` is unusable for multiline purposes.
 
 It supports the `.lineLimit()` view modifier.
 
 ```
 struct ContentView: View {
 @State private var text = ""
 
 var body: some View {
 VStack {
 Text("Custom CSS:")
 ScrollableTextView(text: $text)
 .frame(height: 100)
 }
 }
 }
 ```
 */
struct ScrollableTextView: NSViewRepresentable {
    typealias NSViewType = NSScrollView

    final class Coordinator: NSObject, NSTextViewDelegate {
        var view: ScrollableTextView
        
        init(_ view: ScrollableTextView) {
            self.view = view
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            
            view.text = textView.string
        }
    }
    
    @Binding var text: String
//    @Binding var text: Data
//    var text: String
    var font            = NSFont.controlContentFont(ofSize: 0)
    var borderType      = NSBorderType.noBorder
    var drawsBackground = true
    var isEditable      = false
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> NSViewType {
        let scrollView             = NSTextView.scrollableTextView()
        scrollView.borderType      = borderType // .bezelBorder
        scrollView.drawsBackground = false
        
        let textView = scrollView.documentView as! NSTextView
        textView.delegate           = context.coordinator
        textView.drawsBackground    = false
        textView.isSelectable       = false
        textView.allowsUndo         = false
        textView.textContainerInset = CGSize(width: 5, height: 10)
        textView.textColor                       = .controlTextColor
        textView.isAutomaticDataDetectionEnabled = true
        return scrollView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.borderType      = borderType
        nsView.drawsBackground = drawsBackground
        
        let textView        = (nsView.documentView as! NSTextView)
        textView.isEditable = isEditable
        textView.font       = font
        //        textView.checkTextInDocument(nil)
        if text != textView.string {
            textView.string = text
        }
        
        if let lineLimit = context.environment.lineLimit {
            textView.textContainer?.maximumNumberOfLines = lineLimit
        }
    }
}
