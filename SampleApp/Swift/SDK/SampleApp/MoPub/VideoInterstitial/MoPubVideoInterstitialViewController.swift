//
//  MoPubVideoInterstitialViewController.swift
//  SampleApp
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

import UIKit
import MoPub

// AdUnitIDを適切なものに変えてください
private let adUnitID: String = "f9095a7d80e5405e84021cf54d5caf2a"

class MoPubVideoInterstitialViewController: UIViewController {

    @IBOutlet weak var showButton: UIButton!

    private var interstitial: MPInterstitialAdController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTouchUpLoadAd(button: UIButton) {
        self.interstitial = MPInterstitialAdController(forAdUnitId: adUnitID)
        self.interstitial?.delegate = self
        self.interstitial?.loadAd()
    }

    @IBAction func didTouchUpShowAd(button: UIButton) {
        guard let interstitial = self.interstitial, interstitial.ready else {
            return
        }
        interstitial.show(from: self)
    }

}

extension MoPubVideoInterstitialViewController: MPInterstitialAdControllerDelegate {

    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        print(#function)
        showButton.isEnabled = true
    }

    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
        print(#function, error!)
    }

    func interstitialWillAppear(_ interstitial: MPInterstitialAdController!) {
        print(#function)
    }

    func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
        print(#function)
    }

    func interstitialDidExpire(_ interstitial: MPInterstitialAdController!) {
        print(#function)
    }

    func interstitialWillDisappear(_ interstitial: MPInterstitialAdController!) {
        print(#function)
    }

    func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
        print(#function)
        showButton.isEnabled = false
    }

    func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
        print(#function)
    }

}
