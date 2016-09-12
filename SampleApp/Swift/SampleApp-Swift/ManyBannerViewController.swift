//
//  ManyBannerViewController.swift
//  SampleApp-Swift
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class ManyBannerViewController: UIViewController, FluctBannerViewDelegate {

    @IBOutlet weak var headerBanner: FluctBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let footerBanner = FluctBannerView.init(frame: CGRectMake(0, CGRectGetHeight(self.view.frame) - 100, 320, 50))
        footerBanner.center.x = self.view.center.x
        headerBanner?.delegate = self
        footerBanner.delegate = self
        headerBanner?.setMediaID("0000000108")
        footerBanner.setMediaID("0000000108")
        self.view.addSubview(headerBanner)
        self.view.addSubview(footerBanner)
    }

    func fluctBannerView(bannerView: FluctBannerView!, callbackValue: Int) {
        print(callbackValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
