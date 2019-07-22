//
//  AppDelegate.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 共通メディアIDを設定する場合は下記のメソッドを使用する
        // FluctSDK.sharedInstance().setBannerConfiguration("0000000108")

        // Override point for customization after application launch.
        return true
    }

}
