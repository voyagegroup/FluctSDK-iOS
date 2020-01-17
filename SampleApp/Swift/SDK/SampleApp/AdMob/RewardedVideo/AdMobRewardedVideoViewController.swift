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
        rewardedAd = GADRewardedAd(adUnitID: adUnitID)
        let setting = FSSRewardedVideoSetting.default
        // UnityAdsだけ再生しない
        setting.activation.isUnityAdsActivated = false
        setting.isDebugMode = true
        let extra = GADMAdapterFluctExtras()
        extra.setting = setting

        let request = GADRequest()
        request.register(extra)
        rewardedAd?.load(request) {[weak self] (error) in
            if let error = error {
                print(error)
                return
            }
            self?.showButton.isEnabled = true
        }
    }

    @IBAction func didTouchUpShowAd(button: UIButton) {
        guard let rewardedAd = self.rewardedAd, rewardedAd.isReady else { return }
        rewardedAd.present(fromRootViewController: self, delegate: self)
    }

}

// MARK: - GADRewardedAdDelegate

extension AdMobRewardedVideoViewController: GADRewardedAdDelegate {

    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print(#function)
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print(#function, error)
    }

    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print(#function)
        self.showButton.isEnabled = false
    }

    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print(#function)
    }

}
