//
//  Utils.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct. All rights reserved.

import Foundation

struct FileUtils {

    static func readString(forFileName fileName: String, ofType type: String) -> String {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: type) else { return "" }
        return try! String(contentsOfFile: filePath, encoding: .utf8)
    }
}
