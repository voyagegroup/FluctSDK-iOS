//
//  NativeTableViewController.m
//  SampleApp
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "NativeTableViewController.h"
@import FluctSDK;

@interface NativeTableViewController ()
@property (nonatomic) FSSNativeTableViewCell *cell;
@end

@implementation NativeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 50;
    // storyboardでreuse identifierを設定しない場合に設定
    //  [self.tableView registerClass:FSSNativeTableViewCell.class forCellReuseIdentifier:@"native"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (FSSNativeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.cell = [tableView dequeueReusableCellWithIdentifier:@"native" forIndexPath:indexPath];
        [self.cell loadAdWithGroupID:@"1000076934" unitID:@"1000115021"];
    } else if (indexPath.row == 20) {
        // ※ 広告の更新を行うため広告のインプレッションが発生します
        self.cell = [tableView dequeueReusableCellWithIdentifier:@"native" forIndexPath:indexPath];
        [self.cell loadAdWithGroupID:@"1000076934" unitID:@"1000115021"];
    } else if (indexPath.row == 40) {
        self.cell = [tableView dequeueReusableCellWithIdentifier:@"native" forIndexPath:indexPath];
        [self.cell loadAdWithGroupID:@"1000076934" unitID:@"1000115021"];
    } else {
        UITableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"other"];
        return otherCell;
    }
    return self.cell;
}

@end
