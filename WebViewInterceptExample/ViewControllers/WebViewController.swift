//
//  WebViewController.swift
//  WebViewInterceptExample
//
//  Created by Kevin Yu on 10/4/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit
import WebKit

// MARK: - Constants for WebViewController

private let HALT_SEGUE_IDENTIFIER = "toHalt"
private let BASE_URL_STRING = "https://www.google.com"
private let BASE_URL = URL(string: BASE_URL_STRING)!

final class WebViewController: UIViewController {

    // MARK: - IB Outlets & UI Elements
    
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
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleView
        let request = URLRequest(url: BASE_URL)
        webView.load(request)
    }
    
    // MARK: - Custom Action Methods
    
    @IBAction func dogButtonAction(_ sender: Any) {
        // replace all images with dog
        self.webView.evaluateJavaScript(Scripts.doggify)
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
    
    // do something if we ever find Facebook
    func handleFacebook() {
        // print("Now displaying Facebook halt page")
        performSegue(withIdentifier: HALT_SEGUE_IDENTIFIER, sender: self)
    }
}

extension WebViewController: WKNavigationDelegate {
    
    // handle redirects and loads of new pages
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
            print("redirected to \(url.absoluteString)")
            decisionHandler(.allow)
        }
    }
    
    // called when loading is completed.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        titleView.text = webView.title
    }
    
}

extension WebViewController: WKUIDelegate {
    // handle window.open() for additional taps by loading that request on the
    // current page, instead.
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        if (navigationAction.targetFrame?.isMainFrame ?? true) {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
