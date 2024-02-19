//
//  SwiftUIView.swift
//  
//
//  Created by David Croy on 2/19/24.
//

import SwiftUI
import PDFKit

#if os(macOS)
typealias representable = NSViewRepresentable
#else
typealias representable = UIViewRepresentable
#endif

public struct PDFKitView: representable {
    public typealias UIViewType = PDFView
    
    var data: Data
    let singlePage: Bool
    
    init(_ data: Data, singlePage: Bool = false) {
        self.data       = data
        self.singlePage = singlePage
    }
    
#if os(iOS)
    public func makeUIView(context: Context) -> UIViewType {
        makeView(context: context)
    }
    
    public func updateUIView(_ view: UIViewType, context: Context) {
        //        updateView(view, context: context)
    }
#else
    public func makeNSView(context: Context) -> UIViewType {
        makeView(context: context)
    }
    
    public func updateNSView(_ view: UIViewType, context: Context) {
        updateView(view, context: context)
    }
#endif
    
    private func makeView(context: Context) -> UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView        = PDFView()
        pdfView.document   = PDFDocument(data: data)
        pdfView.autoScales = true
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        return pdfView
    }
    
    private func updateView(_ view: UIViewType, context _: Context) {
        view.document = PDFDocument(data: data)
    }
}
