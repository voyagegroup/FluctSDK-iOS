//
//  BannerTableViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2020 fluct, Inc. All rights reserved.

#import "BannerTableViewController.h"

@interface BannerTableViewController ()
@end

@implementation BannerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"banner" forIndexPath:indexPath];
    } else if (indexPath.row == 15) {
        return [tableView dequeueReusableCellWithIdentifier:@"banner" forIndexPath:indexPath];
    } else if (indexPath.row == 29) {
        return [tableView dequeueReusableCellWithIdentifier:@"banner" forIndexPath:indexPath];
    }

    return [tableView dequeueReusableCellWithIdentifier:@"other" forIndexPath:indexPath];
}
@end
