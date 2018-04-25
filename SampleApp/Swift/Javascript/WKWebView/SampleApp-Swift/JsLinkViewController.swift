//
//  JsLinkViewController.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct. All rights reserved.
//

import UIKit
import WebKit

class JsLinkViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var baseView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webview: WKWebView = WKWebView.init(frame: baseView.frame, configuration: self.createWebviewConfiguration())
        baseView.addSubview(webview)
        let adHtml: String = getHtmlString(fileName: "ad-jslink")
        webview.navigationDelegate = self
        webview.loadHTMLString(adHtml, baseURL: URL.init(string: "https://fluct.jp"))
    }

    public func createWebviewConfiguration() -> WKWebViewConfiguration {
        // 広告識別子連携用のwindowオブジェクトに広告識別子を渡す
        let js: String = String(format: "window.fluctAdParam = {'ifa': '%@', 'lmt': '%@', 'bundle': '%@'}",
                                getIdetifierForAdvertising(), getLimitAdTracking(), getBundleIdentifier())
    
        let userScript: WKUserScript = WKUserScript.init(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController.init()
        userContentController.addUserScript(userScript)
        
        let config: WKWebViewConfiguration = WKWebViewConfiguration.init()
        config.userContentController = userContentController
        return config
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 広告がタップ時に外部ブラウザに遷移する
        if navigationAction.navigationType == .linkActivated {
            UIApplication.shared.open(webView.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
