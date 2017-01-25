//
//  BannerNavigationController.swift
//  SampleApp-Swift
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class BannerNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bannerView = FSSBannerView(frame: CGRect(x: 0, y: self.view.frame.height - 100, width: 320, height: 50))
        bannerView.setMediaID("0000005617")
        bannerView.setRootViewController(self)
        self.view.addSubview(bannerView)
    }
}
