//
//  Q2.swift
//  MoviShow exp
//
//  Created by Mobi iOS on 07/05/26.
//

import Foundation
import SwiftUI
@preconcurrency import WebKit
import AdjustWebBridge
import AdjustSdk

struct Q2: UIViewRepresentable {
    
    let a1: URL
    var a2: () -> Void
    var a3: () -> Void
    
    func makeCoordinator() -> C9 {
        C9(b1: a2, b2: a3)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let c1 = WKWebViewConfiguration()
        let c2 = WKWebView(frame: .zero, configuration: c1)
        
        c2.navigationDelegate = context.coordinator
        c2.uiDelegate = context.coordinator
        
        let c3 = AdjustBridge()
        c3.loadWKWebViewBridge(c2)
        
        var c4 = a1
        var c5 = a1.absoluteString
        
        if !(c5.hasPrefix("http://") || c5.hasPrefix("https://")) {
            c5 = "https://" + c5
        }
        
        if let c6 = URL(string: c5) {
            c4 = c6
        }
        
        c2.load(URLRequest(url: c4))
        return c2
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    class C9: NSObject, WKNavigationDelegate, WKUIDelegate {
        
        var d1: () -> Void
        var d2: () -> Void
        
        init(b1: @escaping () -> Void, b2: @escaping () -> Void) {
            self.d1 = b1
            self.d2 = b2
        }
        
        func webView(_ e1: WKWebView,
                     decidePolicyFor e2: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            guard let e3 = e2.request.url,
                  let e4 = e3.scheme?.lowercased() else {
                decisionHandler(.allow)
                return
            }
            
            if e4 == "error" {
                d1()
                decisionHandler(.cancel)
                return
            }
            
            let e5 = e3.absoluteString.lowercased()
            
            if !e5.hasPrefix("http"),
               UIApplication.shared.canOpenURL(e3) {
                
                UIApplication.shared.open(e3, options: [:]) { _ in
                    self.d1()
                }
                
                decisionHandler(.cancel)
                return
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ f1: WKWebView,
                     didFail f2: WKNavigation!,
                     withError f3: Error) {
            
            let f4 = (f3 as NSError).code
            
            if f4 != NSURLErrorCancelled {
                d1()
            }
        }
        
        func webView(_ g1: WKWebView,
                     didFailProvisionalNavigation g2: WKNavigation!,
                     withError g3: Error) {
            
            let g4 = (g3 as NSError).code
            
            if g4 != NSURLErrorCancelled {
                d1()
            }
        }
        
        func webView(_ h1: WKWebView,
                     didFinish h2: WKNavigation!) {
            d2()
        }
    }
}
