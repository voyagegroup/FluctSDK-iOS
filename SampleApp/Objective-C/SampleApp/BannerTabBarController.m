//
//  TabBarController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

#import "BannerTabBarController.h"
#import <FluctSDK/FluctSDK.h>

@interface BannerTabBarController ()

@end

@implementation BannerTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    FluctBannerView *bannerView = [[FluctBannerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 100, 320, 50)];
    [bannerView setRootViewController:self];
    [self.view addSubview:bannerView];
}

@end
