//
//  ManyBannerViewController.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class ManyBannerViewController: UIViewController, FSSBannerViewDelegate {

    @IBOutlet weak var headerBannerView: FSSBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        headerBannerView?.delegate = self
        headerBannerView?.setMediaID("0000005617")

        let frame = CGRect(x: 0, y: self.view.frame.height - 100, width: 320, height: 50)
        let footerBannerView = FSSBannerView.init(frame: frame)
        footerBannerView.center.x = self.view.center.x
        footerBannerView.delegate = self
        footerBannerView.setMediaID("0000005617")
        self.view.addSubview(footerBannerView)
    }

    func bannerView(_ bannerView: FSSBannerView, callbackType: FSSBannerViewCallbackType) {
        print(callbackType)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
