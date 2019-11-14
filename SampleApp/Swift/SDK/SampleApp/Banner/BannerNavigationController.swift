//
//  BannerNavigationController.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class BannerNavigationController: UINavigationController {

    private var adView: FSSAdView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let adView = FSSAdView(groupId: "1000055927", unitId: "1000084701", adSize: FSSAdSize320x50)
        self.view.addSubview(adView)
        adView.loadAd()
        self.adView = adView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let adViewHeight = self.adView?.frame.height ?? 0.0
        let maxY = self.view.bounds.maxY
        let adViewY = maxY - self.view.layoutMargins.bottom - adViewHeight

        let adViewWidth = self.adView?.frame.width ?? 0.0
        let midX = self.view.bounds.midX
        let adViewX = midX - adViewWidth * 0.5

        var frame = adView?.frame ?? .zero
        frame.origin = CGPoint(x: adViewX, y: adViewY)
        adView?.frame = frame
    }

}
