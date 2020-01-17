//
//  MoPubRewardedVideoViewController.swift
//  SampleApp
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

import UIKit
import MoPub
import FluctSDK
import MoPubMediationAdapterFluct

// AdUnitIDを適切なものに変えてください
private let adUnitID: String = "8d14fd46f8a449f8a5f1de814e4f5fde"

class MoPubRewardedVideoViewController: UIViewController {

    @IBOutlet weak var showButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        MPRewardedVideo.setDelegate(self, forAdUnitId: adUnitID)
    }

    @IBAction func didTouchUpLoadAd(button: UIButton) {
        let setting = FSSRewardedVideoSetting.default
        setting.isDebugMode = true
        setting.activation.isUnityAdsActivated = false
        let mediationSetting = FluctInstanceMediationSettings()
        mediationSetting.setting = setting
        MPRewardedVideo.loadAd(withAdUnitID: adUnitID, withMediationSettings: [setting])
    }

    @IBAction func didTouchUpShowAd(button: UIButton) {
        if MPRewardedVideo.hasAdAvailable(forAdUnitID: adUnitID),
            let rewards = MPRewardedVideo.availableRewards(forAdUnitID: adUnitID),
            let reward = rewards.first as? MPRewardedVideoReward {
            MPRewardedVideo.presentAd(forAdUnitID: adUnitID, from: self, with: reward)
        }
    }

}

// MARK: - MPRewardedVideoDelegate

extension MoPubRewardedVideoViewController: MPRewardedVideoDelegate {

    func rewardedVideoAdDidLoad(forAdUnitID adUnitID: String!) {
        print(#function)
        showButton.isEnabled = true
    }

    func rewardedVideoAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        print(#function, error!)
    }

    func rewardedVideoAdWillAppear(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedVideoAdDidAppear(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedVideoAdDidFailToPlay(forAdUnitID adUnitID: String!, error: Error!) {
        print(#function, error!)
    }

    func rewardedVideoAdShouldReward(forAdUnitID adUnitID: String!, reward: MPRewardedVideoReward!) {
        print(#function, reward!)
    }

    func rewardedVideoAdDidExpire(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedVideoAdDidReceiveTapEvent(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedVideoAdWillLeaveApplication(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedVideoAdWillDisappear(forAdUnitID adUnitID: String!) {
        print(#function)
    }

    func rewardedVideoAdDidDisappear(forAdUnitID adUnitID: String!) {
        print(#function)
        showButton.isEnabled = false
    }
}
