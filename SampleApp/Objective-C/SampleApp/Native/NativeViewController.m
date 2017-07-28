//
//  NativeViewController.m
//  SampleApp
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "NativeViewController.h"
@import FluctSDK;

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FSSNativeView *nativeView = [[FSSNativeView alloc] initWithFrame:CGRectMake(0, 100, 320, 50) groupID: @"1000076934" unitID: @"1000115021"];
    [nativeView loadRequest];
    [self.view addSubview:nativeView];
}

@end
