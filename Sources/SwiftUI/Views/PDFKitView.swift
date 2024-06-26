//
//  SwiftUIView.swift
//  
//
//  Created by David Croy on 2/19/24.
//

import SwiftUI
import PDFKit

#if os(macOS)
typealias Representable = NSViewRepresentable
#else
typealias Representable = UIViewRepresentable
#endif

public struct PDFKitView: Representable {
  public typealias UIViewType = PDFView
  
  var data: Data
  let singlePage: Bool
  
  public init(_ data: Data, singlePage: Bool = false) {
    self.data       = data
    self.singlePage = singlePage
  }
  
  public init(resource: String, singlePage: Bool = false) {
    let url         = Bundle.main.url(forResource: resource,
                                      withExtension: "pdf")
    self.data       = try! Data(contentsOf: url!)
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
