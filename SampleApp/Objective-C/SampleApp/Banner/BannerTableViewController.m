//
//  BannerTableViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2016 fluct, Inc. All rights reserved.

#import "BannerTableViewCell.h"
#import "BannerTableViewController.h"

@interface BannerTableViewController ()

@end

@implementation BannerTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.estimatedRowHeight = 70;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 30;
}

- (BannerTableViewCell *)tableView:(UITableView *)tableView
             cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BannerTableViewCell *cell = [[BannerTableViewCell alloc] init];

  if (indexPath.row == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"banner"];
    [cell.banner setMediaID:(@"0000005617")];
  } else if (indexPath.row == 15) {
    // 再利用時に広告を更新する場合
    // ※ 広告の更新を行うごとに広告のインプレッションが発生します
    cell = [tableView dequeueReusableCellWithIdentifier:@"banner"];
    [cell.banner refreshBanner];
  } else if (indexPath.row == 29) {
    // 再利用時にメディアIDを変更する場合
    cell = [tableView dequeueReusableCellWithIdentifier:@"banner"];
    [cell.banner setMediaID:(@"0000005732")]; // 異なるメディアIDを設定してください
    [cell.banner refreshBanner];
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"other"];
  }

  return cell;
}
@end
