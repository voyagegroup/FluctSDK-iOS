//
//  VideoInterstitialViewController.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

// グループID, ユニットIDを設定して下さい
private let fluctVideoInterstitialGroupID = "1000104107"
private let fluctVideoInterstitialUnitID = "1000160561"

class VideoInterstitialViewController: UIViewController {

    @IBOutlet weak var showButton: UIButton?

    private var interstitial: FSSVideoInterstitial?

    override func viewDidLoad() {
        super.viewDidLoad()

        let setting = FSSVideoInterstitialSetting.default
        setting.isDebugMode = true
        self.interstitial = FSSVideoInterstitial(groupId: fluctVideoInterstitialGroupID,
                                                 unitId: fluctVideoInterstitialUnitID,
                                                 setting: setting)
        self.interstitial?.delegate = self
    }

    @IBAction func didTouchUpLoadAd(_ sender: Any) {
        self.interstitial?.loadAd()
    }

    @IBAction func didTouchUpShowAd(_ sender: Any) {
        guard let interstitial = self.interstitial, interstitial.hasAdAvailable() else { return }
        interstitial.presentAd(from: self)
    }

}

extension VideoInterstitialViewController: FSSVideoInterstitialDelegate {

    func videoInterstitialDidLoad(_ interstitial: FSSVideoInterstitial) {
        print("video interstitial ad \(interstitial) did load")
        showButton?.isEnabled = true
    }

    func videoInterstitial(_ interstitial: FSSVideoInterstitial, didFailToLoadWithError error: Error) {
        print("video interstitial ad \(interstitial) load failed. Because \(error.localizedDescription)")
    }

    func videoInterstitialWillAppear(_ interstitial: FSSVideoInterstitial) {
        print("video interstitial ad \(interstitial) will appear")
    }

    func videoInterstitialDidAppear(_ interstitial: FSSVideoInterstitial) {
        print("video interstitial ad \(interstitial) did appear")
    }

    func videoInterstitial(_ interstitial: FSSVideoInterstitial, didFailToPlayWithError error: Error) {
        print("video interstitial ad \(interstitial) play failed. Because \(error.localizedDescription)")
    }

    func videoInterstitialWillDisappear(_ interstitial: FSSVideoInterstitial) {
        print("video interstitial ad \(interstitial) will disappear")
    }

    func videoInterstitialDidDisappear(_ interstitial: FSSVideoInterstitial) {
        print("video interstitial ad \(interstitial) did disappear")
        showButton?.isEnabled = false
    }

}
