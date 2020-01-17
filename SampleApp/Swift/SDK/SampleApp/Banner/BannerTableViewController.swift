//
//  BannerTableViewController.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2020年 fluct, Inc. All rights reserved.

import UIKit
import FluctSDK

class BannerTableViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "banner", for: indexPath)
        } else if indexPath.row == 15 {
            return tableView.dequeueReusableCell(withIdentifier: "banner", for: indexPath)
        } else if indexPath.row == 29 {
            return tableView.dequeueReusableCell(withIdentifier: "banner", for: indexPath)
        }

        return tableView.dequeueReusableCell(withIdentifier: "other", for: indexPath)
    }

}
