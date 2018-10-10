//
//  WebViewController.swift
//  WebViewInterceptExample
//
//  Created by Kevin Yu on 10/4/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    let HALT_SEGUE_IDENTIFIER = "toHalt"
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set up webView
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        let request = URLRequest(url: URL(string: "https://www.google.com")!)
        self.webView.load(request)
    }
}

// custom ui methods
extension WebViewController {
    func replaceAllImagesWithDog() {
        let script = """
var images = document.getElementsByTagName('img');
        for (var i = 0; i < images.length; i++) {
            images[i].src = "/" + images[i].src;
        }
"""
        self.webView.evaluateJavaScript(script) { (item, error) in
            print(item)
        }
        
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        // if the user tries to link to facebook
        if url.absoluteString.contains("facebook")
            && navigationAction.navigationType == .linkActivated {
            self.handleFacebook()
            decisionHandler(.cancel)
        }
        else {
            decisionHandler(.allow)
        }
    }
    
    func handleFacebook() {
        self.performSegue(withIdentifier: HALT_SEGUE_IDENTIFIER, sender: self)
    }
}

extension WebViewController: WKUIDelegate {
    
}