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

    @IBAction func showInterstitial(_ sender: AnyObject) {
        interstitialView = FSSInterstitialView(mediaID: "0000000108")
        interstitialView?.delegate = self
        interstitialView?.showInterstitialAd()
        // 背景色を設定してインタースティシャル広告を表示する場合
        // interstitialView?.showInterstitialAdWithHexColor("#FF0000")
    }

    func interstitialView(_ interstitialView: FSSInterstitialView!, callbackType: FSSInterstitialViewCallbackType) {
        print(callbackType)
        switch (callbackType) {
        case .show:
            print("表示しました")
        case .tap:
            print("タップしました")
        case .close:
            print("閉じました")
        case .cancel:
            print("キャンセルされました")
        case .offline:
            print("圏外です")
        case .mediaIDError:
            print("メディアIDが不正な値です")
        case .noConfig:
            print("メディアIDに設定されていません")
        case .sizeError:
            print("表示する端末のサイズより広告が大きいです")
        case .getConfigError:
            print("広告情報が取得出来ませんでした")
        case .otherError:
            print("その他のエラーです")
        @unknown default:
            break
        }
    }

    // 画面の回転時にインタースティシャルを非表示にする
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        interstitialView?.dismissInterstitialAd()
    }

}
