//
//  AppDelegate.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2020年 fluct, Inc. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initializeAdMob()
        return true
    }

    private func initializeAdMob() {
        // AdMobを使用する場合は以下を追加する
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}
