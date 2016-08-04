//
//  InterstitialViewController.swift
//  FluctSDKSwiftApp
//
//  Created by 中川 慶悟 on 2016/07/19.
//  Copyright © 2016年 中川 慶悟. All rights reserved.
//

import UIKit
import FluctSDK

class InterstitialViewController: UIViewController, FluctInterstitialViewDelegate {
   
    var interstitialView: FluctInterstitialView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showInterstitial(sender: AnyObject) {
        interstitialView = FluctInterstitialView(mediaID: "0000000108")
        interstitialView?.delegate = self
        interstitialView?.showInterstitialAd()
        // 背景色を設定してインタースティシャル広告を表示する場合
        // interstitialView?.showInterstitialAdWithHexColor("#FF0000")
    }

    func fluctInterstitialView(interstitialView: FluctInterstitialView!, callbackValue: Int) {
        print(callbackValue)
        switch FluctInterstitialViewCallbackType(rawValue: callbackValue) {
            case .Show?:
                print("表示しました")
            case .Tap?:
                print("タップしました")
            case .Close?:
                print("閉じました")
            case .Cancel?:
                print("キャンセルされました")
            case .Offline?:
                print("圏外です")
            case .MediaIDError?:
                print("メディアIDが不正な値です")
            case .NoConfig?:
                print("メディアIDに設定されていません")
            case .SizeError?:
                print("表示する端末のサイズより広告が大きいです")
            case .GetConfigError?:
                print("広告情報が取得出来ませんでした")
            case .OtherError?:
                print("その他のエラーです")
            default:
                break
        }
    }

    // 画面の回転時にインタースティシャルを非表示にする
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        interstitialView?.dismissInterstitialAd()
    }

}
