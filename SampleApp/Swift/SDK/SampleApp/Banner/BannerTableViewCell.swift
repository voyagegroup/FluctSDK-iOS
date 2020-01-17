//
//  BannerTableViewCell.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2020年 fluct, Inc. All rights reserved.

import UIKit
import FluctSDK

class BannerTableViewCell: UITableViewCell {

    private var adView: FSSAdView?

    override func awakeFromNib() {
        super.awakeFromNib()

        let adView = FSSAdView(groupId: "1000055927", unitId: "1000084701", adSize: FSSAdSize320x50)
        self.contentView.addSubview(adView)
        adView.loadAd()
        self.adView = adView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        adView?.center = self.contentView.center
    }

}
