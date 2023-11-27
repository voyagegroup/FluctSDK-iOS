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

    private var interstitial: GADInterstitialAd?

    @IBAction func didTouchUpLoadAd(button: UIButton) {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) {[weak self] (ad, error) in
            if let error = error {
                print(#function, error)
                return
            }

            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            self?.showButton.isEnabled = true
        }
    }

    @IBAction func didTouchUpShowAd(button: UIButton) {
        guard let interstitial = self.interstitial else { return }
        interstitial.present(fromRootViewController: self)
    }

}

extension AdMobVideoInterstitialViewController: GADFullScreenContentDelegate {

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print(#function, error)
    }

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print(#function)
    }

    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print(#function)
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print(#function)
        self.showButton.isEnabled = false
    }
}
