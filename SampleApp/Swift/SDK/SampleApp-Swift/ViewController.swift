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

    @IBAction func didTouchUpCloseButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
