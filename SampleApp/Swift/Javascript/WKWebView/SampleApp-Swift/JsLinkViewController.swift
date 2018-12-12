//
//  JsLinkViewController.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct. All rights reserved.
//

import UIKit
import WebKit

/**
 連携方法2
 JavaScriptのwindowオブジェクトにターゲティングパラメータを埋め込むサンプル
 */

class JsLinkViewController: UIViewController, WKNavigationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = WKWebView(frame: view.frame, configuration: createWebviewConfiguration())
        webView.navigationDelegate = self
        view.addSubview(webView)

        // 2. 広告タグをwebviewで読み込む
        let adHtml = FileUtils.readString(forFileName: "ad-jslink", ofType: "html")
        webView.loadHTMLString(adHtml, baseURL: URL(string: "https://fluct.jp")!)
    }

    public func createWebviewConfiguration() -> WKWebViewConfiguration {
        // ターゲティングパラメータの取得
        let ifa = AdTargetingParameter.idetifierForAdvertising
        let lmt = AdTargetingParameter.limitAdTracking
        let bundle = AdTargetingParameter.bundleIdentifier

        // 1. windowオブジェクトにターゲティングパラメータを格納する
        let js = "window.fluctAdParam = {'ifa': '\(ifa)', 'lmt': '\(lmt)', 'bundle': '\(bundle)'}"
        let userScript = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: true)

        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)

        let config = WKWebViewConfiguration()
        config.userContentController = userContentController

        return config
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 3. 広告のリンクをタップした時に外部Safariを開く
        if navigationAction.navigationType == .linkActivated {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }
}
