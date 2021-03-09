//
//  AdMobBannerViewController.swift
//  SampleApp
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

import UIKit
import GoogleMobileAds

// AdUnitIDを適切なものに変えてください
private let adUnitID: String = "ca-app-pub-3010029359415397/1722697861"
// AdSizeを適切なものに変えてください
private let adSize: GADAdSize = kGADAdSizeBanner

class AdMobBannerViewController: UIViewController {

    private var bannerView: GADBannerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.rootViewController = self
        bannerView.adUnitID = adUnitID

        view.addSubview(bannerView)
        self.bannerView = bannerView
        bannerView.load(GADRequest())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bannerView?.center = view.center
    }

}

// MARK: - GADBannerViewDelegate

extension AdMobBannerViewController: GADBannerViewDelegate {

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print(#function)
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print(#function)
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print(#function, error)
    }

}
