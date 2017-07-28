//
//  NativeTableViewController.swift
//  SampleApp-Swift
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

import UIKit
import FluctSDK

class NativeTableViewController: UITableViewController {
    
    var cell: FSSNativeTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 50
        // storyboardで reuse identifierを設定しない場合に設定
        // self.tableView.register(FSSNativeTableViewCell.self, forCellReuseIdentifier: "test")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "native", for: indexPath) as! FSSNativeTableViewCell
            cell.loadAd(withGroupID: "1000076934", unitID: "1000115021")
        } else if indexPath.row == 20 {
            // ※ 広告の更新を行うため広告のインプレッションが発生します
            cell = tableView.dequeueReusableCell(withIdentifier: "native", for: indexPath) as! FSSNativeTableViewCell
            cell.loadAd(withGroupID: "1000076934", unitID: "1000115021")
        } else if (indexPath.row == 40) {
            cell = tableView.dequeueReusableCell(withIdentifier: "native", for: indexPath) as! FSSNativeTableViewCell
            cell.loadAd(withGroupID: "1000076934", unitID: "1000115021")
        } else {
            let otherCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "other", for: indexPath)
            return otherCell
        }
        return cell
    }
}
