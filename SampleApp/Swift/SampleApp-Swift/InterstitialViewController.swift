//
//  InterstitialViewController.swift
//  SampleApp-Swift
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class InterstitialViewController: UIViewController, FSSInterstitialViewDelegate {

    var interstitialView: FSSInterstitialView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showInterstitial(sender: AnyObject) {
        interstitialView = FSSInterstitialView(mediaID: "0000000108")
        interstitialView?.delegate = self
        interstitialView?.showInterstitialAd()
        // 背景色を設定してインタースティシャル広告を表示する場合
        // interstitialView?.showInterstitialAdWithHexColor("#FF0000")
    }

    func interstitialView(interstitialView: FSSInterstitialView!, callbackType: FSSInterstitialViewCallbackType) {
        print(callbackType)
        switch (callbackType) {
        case .Show:
            print("表示しました")
        case .Tap:
            print("タップしました")
        case .Close:
            print("閉じました")
        case .Cancel:
            print("キャンセルされました")
        case .Offline:
            print("圏外です")
        case .MediaIDError:
            print("メディアIDが不正な値です")
        case .NoConfig:
            print("メディアIDに設定されていません")
        case .SizeError:
            print("表示する端末のサイズより広告が大きいです")
        case .GetConfigError:
            print("広告情報が取得出来ませんでした")
        case .OtherError:
            print("その他のエラーです")
        }
    }

    // 画面の回転時にインタースティシャルを非表示にする
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        interstitialView?.dismissInterstitialAd()
    }

}
