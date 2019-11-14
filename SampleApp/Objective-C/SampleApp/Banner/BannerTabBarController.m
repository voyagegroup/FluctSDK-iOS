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
@property (nonatomic) FSSAdView *adView;
@end

@implementation BannerTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    FSSAdView *adView = [[FSSAdView alloc] initWithGroupId:@"1000055927" unitId:@"1000084701" adSize:FSSAdSize320x50];
    [self.view addSubview:adView];
    [adView loadAd];
    self.adView = adView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat adViewHeight = CGRectGetHeight(self.adView.frame);
    CGFloat maxY = CGRectGetMaxY(self.view.bounds);
    CGFloat adViewY = maxY - CGRectGetHeight(self.tabBar.frame) - adViewHeight;

    CGFloat midX = CGRectGetMidX(self.view.bounds);
    CGFloat adViewX = midX - CGRectGetWidth(self.adView.frame) * 0.5;

    CGRect adViewFrame = self.adView.frame;
    adViewFrame.origin = CGPointMake(adViewX, adViewY);
    self.adView.frame = adViewFrame;
}

@end
