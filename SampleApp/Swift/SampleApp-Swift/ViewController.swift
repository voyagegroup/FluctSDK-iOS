//
//  ViewController.swift
//  SampleApp-Swift
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTouchUpCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
