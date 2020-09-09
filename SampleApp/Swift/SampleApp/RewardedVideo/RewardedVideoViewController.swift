//
//  RewardedVideoViewController.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2020年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

// グループID, ユニットIDを設定して下さい
private let fluctRewardedVideoGroupID = "1000083204"
private let fluctRewardedVideoUnitID = "1000124351"

class RewardedVideoViewController: UIViewController, FSSRewardedVideoDelegate {

    @IBOutlet weak var showButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期化及びデリゲート設定
        FSSRewardedVideo.shared.delegate = self
        let setting = FSSRewardedVideoSetting.default
        setting.isDebugMode = true
        FSSRewardedVideo.shared.setting = setting
    }

    @IBAction func didTouchUpLoadAd(_ sender: Any) {
        // 動画リワード広告の読み込み
        FSSRewardedVideo.shared.load(withGroupId: fluctRewardedVideoGroupID,
                                     unitId: fluctRewardedVideoUnitID)
    }

    @IBAction func didTouchUpShowAd(_ sender: Any) {
        // 動画リワード広告が表示可能か確認
        if FSSRewardedVideo.shared.hasAdAvailable(forGroupId: fluctRewardedVideoGroupID,
                                                  unitId: fluctRewardedVideoUnitID) {
            // 動画リワード広告の表示
            FSSRewardedVideo.shared.presentAd(forGroupId: fluctRewardedVideoGroupID,
                                              unitId: fluctRewardedVideoUnitID,
                                              from: self)
        }
    }

    // MARK: FSSRewardedVideoDelegate

    func rewardedVideoDidLoad(forGroupID groupId: String, unitId: String) {
        print("rewarded video ad did load")
        showButton.isEnabled = true
    }

    func rewardedVideoShouldReward(forGroupID groupId: String, unitId: String) {
        print("should rewarded for app user")
        showButton.isEnabled = false
    }

    func rewardedVideoDidFailToLoad(forGroupId groupId: String, unitId: String, error: Error) {
        // refs: error code list are FSSVideoError.h
        print("rewarded video ad load failed. Because \(error)")
    }

    func rewardedVideoWillAppear(forGroupId groupId: String, unitId: String) {
        print("rewarded video ad will appear")
    }

    func rewardedVideoDidAppear(forGroupId groupId: String, unitId: String) {
        print("rewarded video ad did appear")
    }

    func rewardedVideoWillDisappear(forGroupId groupId: String, unitId: String) {
        print("rewarded video ad will disappear")
    }

    func rewardedVideoDidDisappear(forGroupId groupId: String, unitId: String) {
        print("rewarded video ad did disappear")
    }

    func rewardedVideoDidFailToPlay(forGroupId groupId: String, unitId: String, error: Error) {
        // refs: error code list are FSSVideoError.h
        print("rewarded video ad play failed. Because \(error)")
    }

}
