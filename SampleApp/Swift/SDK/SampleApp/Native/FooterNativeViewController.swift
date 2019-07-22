//
//  FooterNativeViewController.swift
//  SampleApp
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class FooterNativeViewController: UIViewController {

    @IBOutlet weak var nativeView: FSSNativeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        nativeView.setGroupID("1000076934", unitID: "1000115021")
        nativeView.loadRequest()
    }

}
