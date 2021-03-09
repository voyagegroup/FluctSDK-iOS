//
//  AdMobRewardedVideoViewController.swift
//  SampleApp
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK
import GoogleMobileAdsMediationFluct
import GoogleMobileAds

// AdUnitIDを適切なものに変えてください
private let adUnitID: String = "ca-app-pub-3010029359415397/4697035240"

class AdMobRewardedVideoViewController: UIViewController {

    @IBOutlet weak var showButton: UIButton!

    private var rewardedAd: GADRewardedAd?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTouchUpLoadAd(button: UIButton) {
        let request = GADRequest()

        let setting = FSSRewardedVideoSetting.default
        // UnityAdsだけ再生しない
        setting.activation.isUnityAdsActivated = false
        setting.isDebugMode = true
        let extra = GADMAdapterFluctExtras()
        extra.setting = setting
        request.register(extra)

        GADRewardedAd.load(withAdUnitID: adUnitID, request: request) {[weak self] (ad, error) in
            if let error = error {
                print(error)
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.showButton.isEnabled = true
        }
    }

    @IBAction func didTouchUpShowAd(button: UIButton) {
        guard let rewardedAd = self.rewardedAd else { return }
        rewardedAd.present(fromRootViewController: self) {[rewardedAd] in
            print(rewardedAd.adReward)
        }
    }

}

extension AdMobRewardedVideoViewController: GADFullScreenContentDelegate {

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print(#function, error)
    }

    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
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
