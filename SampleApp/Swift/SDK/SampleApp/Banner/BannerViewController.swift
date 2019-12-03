//
//  ViewController.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class BannerViewController: UIViewController, FSSAdViewDelegate {

    private var adView: FSSAdView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let adView = FSSAdView(groupId: "1000055927", unitId: "1000084701", adSize: FSSAdSize320x50)
        adView.delegate = self
        self.view.addSubview(adView)
        adView.loadAd()
        self.adView = adView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let adViewHeight = self.adView?.frame.height ?? 0.0
        let maxY = self.view.bounds.maxY
        let adViewY = maxY - self.view.layoutMargins.bottom - adViewHeight

        let adViewWidth = self.adView?.frame.width ?? 0.0
        let midX = self.view.bounds.midX
        let adViewX = midX - adViewWidth * 0.5

        var frame = adView?.frame ?? .zero
        frame.origin = CGPoint(x: adViewX, y: adViewY)
        adView?.frame = frame
    }

    // MARK: - FSSAdViewDelegate

    func adViewDidStoreAd(_ adView: FSSAdView) {
        print("広告表示が完了しました")
    }

    func adView(_ adView: FSSAdView, didFailToStoreAdWithError error: Error) {
        print(error.localizedDescription)
        let fluctError = FSSAdViewError(rawValue: (error as NSError).code) ?? .unknown
        switch fluctError {
        case .unknown:
            print("Unkown Error")
        case .notConnectedToInternet:
            print("ネットワークエラー")
        case .serverError:
            print("サーバーエラー")
        case .noAds:
            print("表示する広告がありません")
        case .badRequest:
            print("groupId / unitId / 登録されているbundleのどれかが間違っています")
        @unknown default:
            fatalError()
        }
    }

    func willLeaveApplicationForAdView(_ adView: FSSAdView) {
        print("広告へ遷移します")
    }

}
