//
//  AppDelegate.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2020年 fluct, Inc. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MoPubSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initializeAdMob()
        initializeMoPub()
        return true
    }

    private func initializeAdMob() {
        // AdMobを使用する場合は以下を追加する
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    private func initializeMoPub() {
        // MoPubを使用する場合は以下を追加する
        let sdkConfig = MPMoPubConfiguration(adUnitIdForAppInitialization: "49b7ea66f5124f47b0d89e85b40137bf")
        MoPub.sharedInstance().initializeSdk(with: sdkConfig, completion: nil)
    }

}
