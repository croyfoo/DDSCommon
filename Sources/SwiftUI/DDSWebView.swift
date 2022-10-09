//
//  WebView.swift
//  FoldingText
//
//  Created by David Croy on 6/7/22.
//

import SwiftUI
import WebKit

struct DDSWebView: NSViewRepresentable {

    public var html: String
    let preferences   = WKPreferences()
    let configuration = WKWebViewConfiguration()

    public func makeNSView(context: Context) -> WKWebView {
#if DEBUG
        preferences.setValue(true, forKey: "developerExtrasEnabled")
#endif
        preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        configuration.preferences                    = preferences
        configuration.suppressesIncrementalRendering = true
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = webView
        return webView
    }
    
    public func updateNSView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
    }
}

extension WKWebView: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationResponse: WKNavigationResponse,
                        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else { return decisionHandler(.allow) }
        
        switch navigationAction.navigationType {
            case .linkActivated:
                if let scheme = url.scheme, configuration.urlSchemeHandler(forURLScheme: scheme) != nil {
                    decisionHandler(.allow)
                    return
                }
                
                decisionHandler(.cancel)
                openURL(url: url)
            default:
                decisionHandler(.allow)
        }
    }
    
    @available(iOSApplicationExtension, unavailable)
    func openURL(url: URL) {
#if os(iOS)
        _ = UIApplication.shared.openURL(fileURL)
#elseif os(macOS)
        NSWorkspace.shared.open(url)
#endif
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        didLoadSuccessfully?()
    }
}

//struct WebView_Previews: PreviewProvider {
//    static let parser = MarkdownParser()
//    static let html = parser.html(from: "# Foo")
//    static var previews: some View {
////        WebView(html: "<h1>foo</h1>")
//        WebView(html: html)
//    }
//}
