//
//  BannerTableViewController.swift
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.

import UIKit

class BannerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 70
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BannerTableViewCell {
        var cell: BannerTableViewCell!

        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "banner", for: indexPath) as? BannerTableViewCell
            cell.banner.setMediaID("0000005617")
        } else if indexPath.row == 15 {
            // 再利用時に広告を更新する場合
            // ※ 広告の更新を行うごとに広告のインプレッションが発生します
            cell = tableView.dequeueReusableCell(withIdentifier: "banner", for: indexPath) as? BannerTableViewCell
            cell.banner.refreshBanner()
        } else if indexPath.row == 29 {
            // 再利用時にメディアIDを変更する場合
            cell = tableView.dequeueReusableCell(withIdentifier: "banner", for: indexPath) as? BannerTableViewCell
            cell.banner.setMediaID("0000005732") // 異なるメディアIDを設定してください
            cell.banner.refreshBanner()
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "other", for: indexPath) as? BannerTableViewCell
        }

        return cell
    }
}
