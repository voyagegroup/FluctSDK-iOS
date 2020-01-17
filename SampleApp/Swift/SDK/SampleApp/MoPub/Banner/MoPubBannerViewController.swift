//
//  MoPubBannerViewController.swift
//  SampleApp
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

import UIKit
import MoPub

// AdUnitIDを適切なものに変えてください
private let adUnitID: String = "49b7ea66f5124f47b0d89e85b40137bf"

class MoPubBannerViewController: UIViewController {

    private var adView: MPAdView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if let adView = MPAdView(adUnitId: adUnitID) {
            adView.delegate = self
            adView.frame = CGRect(x: 0, y: 0, width: 320, height: kMPPresetMaxAdSize50Height.height)
            view.addSubview(adView)
            adView.loadAd(withMaxAdSize: kMPPresetMaxAdSize50Height)
            self.adView = adView
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adView?.center = view.center
    }

}

extension MoPubBannerViewController: MPAdViewDelegate {

    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }

    func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
        print(#function)
    }

    func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
        print(#function, error!)
    }

    func didDismissModalView(forAd view: MPAdView!) {
        print(#function)
    }

    func willPresentModalView(forAd view: MPAdView!) {
        print(#function)
    }

    func willLeaveApplication(fromAd view: MPAdView!) {
        print(#function)
    }

}
