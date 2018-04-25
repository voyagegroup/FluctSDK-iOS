//
//  RewardedVideoViewController.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

// グループID, ユニットIDを設定して下さい
let FLUCT_REWARDED_VIDEO_GROUP_ID = ""
let FLUCT_REWARDED_VIDEO_UNIT_ID = ""

class RewardedVideoViewController: UIViewController, FSSRewardedVideoDelegate {
    @IBOutlet weak var showButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期化及びデリゲート設定
        FSSRewardedVideo.setDelegate(self)
    }
    
    @IBAction func didTouchUpLoadAd(_ sender: Any) {
        // 動画リワード広告の読み込み
        let targeting = FSSAdRequestTargeting()
        targeting.userID = "fluct_user" // fluct_userという文字列を sha256 ハッシュ関数にかけた結果の e313cbbd0628f189fc60ced535b64c92726f3f8d1dd2e04aa20847ff332c8278 という文字列がfluctのサーバに送信されます
        FSSRewardedVideo.sharedInstance().load(withGroupId: FLUCT_REWARDED_VIDEO_GROUP_ID, unitId: FLUCT_REWARDED_VIDEO_UNIT_ID, targeting: targeting) // targeting パラメータの設定は任意で、頂いたお問合わせの調査等で利用します。詳しくは https://github.com/voyagegroup/FluctSDK-iOS/wiki/Swift%E3%81%A7%E3%81%AE%E5%8B%95%E7%94%BB%E3%83%AA%E3%83%AF%E3%83%BC%E3%83%89%E5%BA%83%E5%91%8A%E5%AE%9F%E8%A3%85 をご参照下さい
    }

    @IBAction func didTouchUpShowAd(_ sender: Any) {
        // 動画リワード広告が表示可能か確認
        if FSSRewardedVideo.sharedInstance().hasAdAvailable(forGroupId: FLUCT_REWARDED_VIDEO_GROUP_ID, unitId: FLUCT_REWARDED_VIDEO_UNIT_ID) {
            // 動画リワード広告の表示
            FSSRewardedVideo.sharedInstance().presentAd(forGroupId: FLUCT_REWARDED_VIDEO_GROUP_ID, unitId: FLUCT_REWARDED_VIDEO_UNIT_ID, from: self)
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
        // refs: error code list are FSSRewardedVideoError.h
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
        // refs: error code list are FSSRewardedVideoError.h
        print("rewarded video ad play failed. Because \(error)")
    }
}
