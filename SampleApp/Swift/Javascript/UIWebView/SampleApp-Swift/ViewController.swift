//
//  ViewController.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct. All rights reserved.
//

import UIKit

let IFA = "IFA_REPLACE_STRING"
let LMT = "LMT_REPLACE_STRING"
let BUNDLE = "BUNDLE_REPLACE_STRING"

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var adView: UIWebView!
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

        adView.delegate = self
        adView.loadHTMLString(adhtml, baseURL: URL.init(string: "http://fluct.jp"))
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        // 広告がタップ時に外部ブラウザに遷移する
        if navigationType == .linkClicked {
            // open(_:​options:​completion​Handler:​) require iOS 10.0+
            // iOS 2.0-10.0 use open​URL(_:​)
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
}
