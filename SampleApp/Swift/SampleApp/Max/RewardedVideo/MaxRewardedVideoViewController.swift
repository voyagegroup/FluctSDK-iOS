//
//  MaxRewardedVideoViewController.swift
//  SampleApp
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK
import AppLovinSDK

// AdUnitIDを適切なものに変えてください
private let adUnitID: String = "f681a5b35ac7822d"

class MaxRewardedVideoViewController: UIViewController {

    @IBOutlet weak var showButton: UIButton!

    private var rewardedAd: MARewardedAd!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTouchUpLoadAd(button: UIButton) {
        // Fluct Setting
        let setting = FSSRewardedVideoSetting.default
        setting.isTestMode = true
        setting.isDebugMode = true

        FSSRewardedVideo.shared.setting = setting

        rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: adUnitID)
        rewardedAd.delegate = self
        rewardedAd.load()

        showButton?.isEnabled = false
    }

    @IBAction func didTouchUpShowAd(button: UIButton) {
        if rewardedAd.isReady {
            rewardedAd.show()
        }
    }

}

extension MaxRewardedVideoViewController: MARewardedAdDelegate {

    // MARK: MAAdDelegate Protocol

    func didLoad(_ ad: MAAd) {
        print(#function)
        showButton?.isEnabled = true
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        print(#function, error)
        showButton?.isEnabled = false
    }

    func didDisplay(_ ad: MAAd) {
        print(#function)
    }

    func didClick(_ ad: MAAd) {
        print(#function)
    }

    func didHide(_ ad: MAAd) {
        print(#function)
        showButton?.isEnabled = false
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        print(#function, error)
        showButton?.isEnabled = false
    }

    // MARK: MARewardedAdDelegate Protocol

    func didStartRewardedVideo(for ad: MAAd) {
        print(#function)
    }

    func didCompleteRewardedVideo(for ad: MAAd) {
        print(#function)
    }

    func didRewardUser(for ad: MAAd, with reward: MAReward) {
        print(#function)
    }
}
