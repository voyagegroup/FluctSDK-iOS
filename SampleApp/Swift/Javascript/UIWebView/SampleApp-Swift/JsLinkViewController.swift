//
//  JsLinkViewController.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct. All rights reserved.
//

import UIKit

// アプリ内で遷移させるドメインを指定
let APP_IN_VIEW_DOMAIN = "voyagegroup.com"

class JsLinkViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var adView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let adhtml: String = getHtmlString(fileName: "ad-jslink")

        adView.delegate = self
        adView.loadHTMLString(adhtml, baseURL: URL.init(string: "http://fluct.jp"))
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        // HTMLに記述した広告識別子連携用の関数に広告識別子を渡す
        let js: String = String(format: "window.fluctAdParam = {'ifa': '%@', 'lmt': '%@', 'bundle': '%@'}",
                                getIdetifierForAdvertising(), getLimitAdTracking(), getBundleIdentifier())
        webView.stringByEvaluatingJavaScript(from: js)

        // 広告がタップ時 かつ 指定したドメイン以外の時、外部ブラウザに遷移する
        if navigationType == .linkClicked && request.url?.absoluteURL.host != APP_IN_VIEW_DOMAIN {
            // open(_:​options:​completion​Handler:​) require iOS 10.0+
            // iOS 2.0-10.0 use open​URL(_:​)
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
}
