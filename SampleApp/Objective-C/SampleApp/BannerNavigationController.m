//
//  BannerNavigationController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

#import "BannerNavigationController.h"
#import <FluctSDK/FluctSDK.h>

@interface BannerNavigationController ()

@end

@implementation BannerNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    FluctBannerView *bannerView = [[FluctBannerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, 320, 50)];
    [bannerView setRootViewController:self];
    [self.view addSubview:bannerView];
}

@end
