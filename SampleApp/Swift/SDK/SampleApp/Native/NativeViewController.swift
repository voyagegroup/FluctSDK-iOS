//
//  NativeViewController.swift
//  SampleApp
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class NativeViewController: UIViewController, FSSNativeViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 100, width: 320, height: 50)
        let nativeView = FSSNativeView.init(frame: frame, groupID: "1000076934", unitID: "1000115021")
        nativeView.delegate = self
        self.view.addSubview(nativeView)
        nativeView.loadRequest()
    }

    func nativeView(_ nativeView: FSSNativeView, callbackType: FSSNativeViewCallbackType) {
        switch callbackType {
        case .loadFinish:
            print("広告の読み込みが完了しました")
        case .tap:
            print("広告がタップされました")
        @unknown default:
            break
        }
    }

    func nativeView(_ nativeView: FSSNativeView, callbackErrorType: FSSErrorType) {
        switch callbackErrorType {
        case .noAd:
            print("広告取得できませんでした")
        case .badRequest:
            print("リクエスト情報に誤りがあります")
        case .networkConnection:
            print("ネットワークが未接続です")
        case .serverError:
            print("サーバ側でエラーが発生しました")
        case .other:
            print("その他のエラーです")
        @unknown default:
            break
        }
    }
}
