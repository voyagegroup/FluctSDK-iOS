//
//  ManyBannerViewController.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class ManyBannerViewController: UIViewController {

    private var topAdView: FSSAdView?
    private var bottomAdView: FSSAdView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let topAdView = FSSAdView(groupId: "1000055927", unitId: "1000084701", adSize: FSSAdSize320x50)
        self.view.addSubview(topAdView)
        topAdView.loadAd()
        self.topAdView = topAdView

        let bottomAdView = FSSAdView(groupId: "1000055927", unitId: "1000084701", adSize: FSSAdSize320x50)
        self.view.addSubview(bottomAdView)
        bottomAdView.loadAd()
        self.bottomAdView = bottomAdView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let minY = self.view.bounds.minY
        let topAdViewY = minY + self.view.layoutMargins.top

        let maxY = self.view.bounds.maxY
        let bottomAdViewHeight = self.bottomAdView?.frame.height ?? 0.0
        let bottomAdViewY = maxY - self.view.layoutMargins.bottom - bottomAdViewHeight

        let midX = self.view.bounds.midX
        let topAdViewWidth = self.topAdView?.frame.width ?? 0.0
        let topAdViewX = midX - topAdViewWidth * 0.5

        let bottomAdViewWidth = self.bottomAdView?.frame.width ?? 0.0
        let bottomAdViewX = midX - bottomAdViewWidth * 0.5

        var topAdViewFrame = self.topAdView?.frame ?? .zero
        topAdViewFrame.origin = CGPoint(x: topAdViewX, y: topAdViewY)
        self.topAdView?.frame = topAdViewFrame

        var bottomAdViewFrame = self.bottomAdView?.frame ?? .zero
        bottomAdViewFrame.origin = CGPoint(x: bottomAdViewX, y: bottomAdViewY)
        self.bottomAdView?.frame = bottomAdViewFrame

    }
}
