//
//  MoPubRewardedVideoViewController.swift
//  SampleApp
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

import UIKit
import MoPubSDK
import FluctSDK
import MoPubMediationAdapterFluct

// AdUnitIDを適切なものに変えてください
private let adUnitID: String = "8d14fd46f8a449f8a5f1de814e4f5fde"

class MoPubRewardedVideoViewController: UIViewController {

    @IBOutlet weak var showButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        MPRewardedAds.setDelegate(self, forAdUnitId: adUnitID)
    }

    @IBAction func didTouchUpLoadAd(button: UIButton) {
        let setting = FSSRewardedVideoSetting.default
        setting.isDebugMode = true
        setting.activation.isUnityAdsActivated = false
        let mediationSetting = FluctInstanceMediationSettings()
        mediationSetting.setting = setting
        MPRewardedAds.loadRewardedAd(withAdUnitID: adUnitID, withMediationSettings: [setting])
    }

    @IBAction func didTouchUpShowAd(button: UIButton) {
        guard MPRewardedAds.hasAdAvailable(forAdUnitID: adUnitID) else {
            return
        }

        let reward = MPRewardedAds.selectedReward(forAdUnitID: adUnitID)
        MPRewardedAds.presentRewardedAd(forAdUnitID: adUnitID, from: self, with: reward)
    }

}

// MARK: - MPRewardedVideoDelegate

extension MoPubRewardedVideoViewController: MPRewardedAdsDelegate {

    func rewardedAdDidLoad(forAdUnitID adUnitID: String!) {
        print(#function)
        showButton.isEnabled = true
    }

    func rewardedAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        print(#function, error!)
    }

    func rewardedAdWillPresent(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedAdDidPresent(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedAdDidFailToShow(forAdUnitID adUnitID: String!, error: Error!) {
        print(#function, error!)
    }

    func rewardedAdShouldReward(forAdUnitID adUnitID: String!, reward: MPReward!) {
        print(#function, reward!)
    }

    func rewardedAdDidExpire(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedAdDidReceiveTapEvent(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedAdWillLeaveApplication(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedAdWillDismiss(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedAdDidDismiss(forAdUnitID adUnitID: String!) {
        print(#function)
        showButton.isEnabled = false
    }
}
