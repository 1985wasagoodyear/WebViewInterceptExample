//
//  WebViewController.swift
//  WebViewInterceptExample
//
//  Created by Kevin Yu on 10/4/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit
import WebKit

private let HALT_SEGUE_IDENTIFIER = "toHalt"

private let doggifyScript = """
var images = document.getElementsByTagName('img');
for (var i = 0; i < images.length; i++) {
images[i].src = "https://raw.githubusercontent.com/1985wasagoodyear/WebViewInterceptExample/master/WebViewInterceptExample/smrtDog.jpeg";
}
"""

final class WebViewController: UIViewController {

    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
            webView.uiDelegate = self
        }
    }
    @IBOutlet var dogButton: UIButton! {
        didSet {
            dogButton.layer.masksToBounds = true
            dogButton.layer.cornerRadius = 30.0
        }
    }
    
    lazy var titleView: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0,
                                     width: 200, height: 100))
        label.textAlignment = .center
        return label;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleView
        let request = URLRequest(url: URL(string: "https://www.google.com")!)
        webView.load(request)
    }
    
    @IBAction func dogButtonAction(_ sender: Any) {
        replaceAllImagesWithDog()
    }
    
    func replaceAllImagesWithDog() {
        self.webView.evaluateJavaScript(doggifyScript)
        { (item, error) in
            if let err = error {
                print("Failed to perform doggification with error: \(err)")
            }
        }
    }
    @IBAction func forwardButton(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
        
    }
    @IBAction func backwardsButton(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
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
        if (url.absoluteString.contains("facebook")
            || url.absoluteString.contains(".fb."))
            && navigationAction.navigationType == .linkActivated {
            // deny access
            handleFacebook()
            decisionHandler(.cancel)
        }
        else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        titleView.text = webView.title
    }
    
    func handleFacebook() {
        performSegue(withIdentifier: HALT_SEGUE_IDENTIFIER, sender: self)
    }
}

extension WebViewController: WKUIDelegate { }
