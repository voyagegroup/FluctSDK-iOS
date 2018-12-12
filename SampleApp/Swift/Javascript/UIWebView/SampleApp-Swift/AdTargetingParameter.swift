//
//  AdTargetingParameter.swift
//  SampleApp-Swift
//
//  Copyright © 2018年 fluct. All rights reserved.
//

import AdSupport

struct AdTargetingParameter {

    private init() {
    }

    static var idetifierForAdvertising: String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }

    static var limitAdTracking: Int {
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? 0 : 1
    }

    static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier!
    }
}
