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
        let bannerView = FluctBannerView(frame: CGRect(x: 0, y: CGRectGetHeight(self.view.frame) - 50, width: 320, height: 50))
        bannerView.setMediaID("0000000108")
        bannerView.setRootViewController(self)
        self.view.addSubview(bannerView)
    }
}