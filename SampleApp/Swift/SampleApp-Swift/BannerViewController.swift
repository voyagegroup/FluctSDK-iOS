//
//  ViewController.swift
//  FluctSDKSwiftApp
//
//  Created by 中川 慶悟 on 2016/07/15.
//  Copyright © 2016年 中川 慶悟. All rights reserved.
//

import UIKit
import FluctSDK

class BannerViewController: UIViewController, FluctBannerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bannerView = FluctBannerView.init(frame: CGRectMake(0, 100, 320, 50))
        bannerView.delegate = self
        bannerView.setMediaID("0000000108")
        self.view.addSubview(bannerView)
    }

    func fluctBannerView(bannerView: FluctBannerView!, callbackValue: Int) {
        print(callbackValue)
        switch(FluctBannerViewCallbackType(rawValue: callbackValue)) {
            case .Load?:
                print("表示しました")
            case .Tap?:
                print("タップしました")
            case .Offline?:
                print("圏外です")
            case .MediaIdError?:
                print("メディアIDが不正な値です")
            case .NoConfig?:
                print("メディアIDに設定されていません")
            case .GetConfigError?:
                print("広告情報が取得出来ませんでした")
            case .OtherError?:
                print("その他のエラーです")
            default:
                break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
