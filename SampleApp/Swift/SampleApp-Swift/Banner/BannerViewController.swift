//
//  ViewController.swift
//  SampleApp-Swift
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class BannerViewController: UIViewController, FSSBannerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bannerView = FSSBannerView.init(frame: CGRect(x: 0, y: 100, width: 320, height: 50))
        bannerView.delegate = self
        bannerView.setMediaID("0000005617")
        self.view.addSubview(bannerView)
    }

    func bannerView(_ bannerView: FSSBannerView, callbackType: FSSBannerViewCallbackType) {
        print(callbackType)
        switch (callbackType) {
        case .load:
            print("表示しました")
        case .loadFinish:
            print("広告の読み込みが完了しました")
        case .tap:
            print("タップしました")
        case .offline:
            print("圏外です")
        case .mediaIdError:
            print("メディアIDが不正な値です")
        case .noConfig:
            print("メディアIDに設定されていません")
        case .getConfigError:
            print("広告設定情報が取得出来ませんでした")
        case .noAd:
            print("広告を取得出来ませんでした。")
        case .otherError:
            print("その他のエラーです")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
