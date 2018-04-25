//
//  ViewController.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct. All rights reserved.
//

import UIKit
import WebKit

let IFA = "IFA_REPLACE_STRING"
let LMT = "LMT_REPLACE_STRING"
let BUNDLE = "BUNDLE_REPLACE_STRING"

class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 広告識別子の取得
        let ifa = getIdetifierForAdvertising()
        let lmt = getLimitAdTracking()
        let bundle = getBundleIdentifier()

        var adhtml: String = getHtmlString(fileName: "ad")

        // 広告識別子を置換
        adhtml = replaceStringWithBaseString(key: IFA, value: ifa, base: adhtml)
        adhtml = replaceStringWithBaseString(key: LMT, value: lmt, base: adhtml)
        adhtml = replaceStringWithBaseString(key: BUNDLE, value: bundle, base: adhtml)

        // WebViewにhtmlをロード
        webview.navigationDelegate = self
        webview.loadHTMLString(adhtml, baseURL: URL.init(string: "http://fluct.jp"))
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
