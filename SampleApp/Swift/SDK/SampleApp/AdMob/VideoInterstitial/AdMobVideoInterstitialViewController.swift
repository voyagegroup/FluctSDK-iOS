//
//  AdMobVideoInterstitialViewController.swift
//  SampleApp
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

import UIKit
import GoogleMobileAds

private let adUnitID: String = "ca-app-pub-3010029359415397/5031866416"

class AdMobVideoInterstitialViewController: UIViewController {

    @IBOutlet weak var showButton: UIButton!

    private var interstitial: GADInterstitial?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTouchUpLoadAd(button: UIButton) {
        interstitial = GADInterstitial(adUnitID: adUnitID)
        interstitial?.delegate = self
        interstitial?.load(GADRequest())
    }

    @IBAction func didTouchUpShowAd(button: UIButton) {
        guard let interstitial = self.interstitial, interstitial.isReady else { return }
        interstitial.present(fromRootViewController: self)
    }

}

extension AdMobVideoInterstitialViewController: GADInterstitialDelegate {

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print(#function)
        self.showButton.isEnabled = true
    }

    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print(#function, error)
    }

    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print(#function)
    }

    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print(#function)
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print(#function)
        self.showButton.isEnabled = false
    }

    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print(#function)
    }

    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print(#function)
    }

}
