//
//  NativeTableViewController.m
//  SampleApp
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "NativeTableViewController.h"
@import FluctSDK;

@implementation NativeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 20 == 0) {
        FSSNativeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"native" forIndexPath:indexPath];
        [cell loadAdWithGroupID:@"1000076934" unitID:@"1000115021"];
        return cell;

    } else {
        UITableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"other"];
        return otherCell;
    }
}

@end
