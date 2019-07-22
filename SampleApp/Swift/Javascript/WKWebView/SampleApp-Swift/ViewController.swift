//
//  ViewController.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct. All rights reserved.
//

import UIKit
import WebKit

/**
 連携方法1
 ターゲティングパラメータを置換するサンプル
 */

// 1. 事前にfluct広告タグの広告配信サーバへのリクエストパラメータにターゲティングパラメータを追加する

class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webview: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webview.navigationDelegate = self

        // ターゲティングパラメータの取得
        let ifa = AdTargetingParameter.idetifierForAdvertising
        let lmt = AdTargetingParameter.limitAdTracking
        let bundle = AdTargetingParameter.bundleIdentifier

        // 2. fluctタグを埋め込んだHTMLを表示する前に置換用文字列を実際の値へ置換する
        let adhtml = FileUtils.readString(forFileName: "ad", ofType: "html")
            .replacingOccurrences(of: "${FLUCT_IFA}", with: ifa)
            .replacingOccurrences(of: "${FLUCT_LMT}", with: "\(lmt)")
            .replacingOccurrences(of: "${FLUCT_BUNDLE}", with: bundle)

        // 3. 置換したHTMLをWebViewで読み込む
        webview.loadHTMLString(adhtml, baseURL: URL(string: "http://fluct.jp")!)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 4. 広告のリンクをタップした時に外部Safariを開く
        if navigationAction.navigationType == .linkActivated {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }
}
