//
//  JsLinkViewController.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct. All rights reserved.
//

import UIKit

/**
 連携方法2
 JavaScriptのwindowオブジェクトにターゲティングパラメータを埋め込むサンプル
 */

class JsLinkViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self

        // ターゲティングパラメータの取得
        let ifa = AdTargetingParameter.idetifierForAdvertising
        let lmt = AdTargetingParameter.limitAdTracking
        let bundle = AdTargetingParameter.bundleIdentifier

        // 1. windowオブジェクトにターゲティングパラメータを格納する
        let js = "window.fluctAdParam = {'ifa': '\(ifa)', 'lmt': '\(lmt)', 'bundle': '\(bundle)'}"
        webView.stringByEvaluatingJavaScript(from: js)

        // 2. 広告タグをWebViewで読み込む
        let adHtml = FileUtils.readString(forFileName: "ad-jslink", ofType: "html")
        webView.loadHTMLString(adHtml, baseURL: URL(string: "https://fluct.jp")!)
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        // 3. 広告のリンクをタップした時に外部Safariを開く
        if navigationType == .linkClicked {
            UIApplication.shared.open(request.url!)
            return false
        }

        return true
    }
}
