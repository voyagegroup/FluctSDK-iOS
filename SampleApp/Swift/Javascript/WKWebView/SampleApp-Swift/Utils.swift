//
//  Utils.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct. All rights reserved.

import AdSupport

func getIdetifierForAdvertising() -> String {
    let im: ASIdentifierManager = ASIdentifierManager.shared()
    return im.advertisingIdentifier.uuidString
}

func getLimitAdTracking() -> String {
    let im: ASIdentifierManager = ASIdentifierManager.shared()
    if im.isAdvertisingTrackingEnabled {
        return "0"
    }
    return "1"
}

func getBundleIdentifier() -> String {
    guard let bundle = Bundle.main.bundleIdentifier else { return "" }
    return bundle
}

func replaceStringWithBaseString(key: String?, value: String?, base: String) -> String {
    guard let key: String = key else { return base }
    guard let value: String = value else { return base }
    return base.replacingOccurrences(of: key, with: value)
}

func getHtmlString(fileName: String) -> String {
    guard let filePath = Bundle.main.path(forResource: fileName, ofType: "html") else { return "" }
    return try! String.init(contentsOfFile: filePath, encoding: String.Encoding.utf8)
}
