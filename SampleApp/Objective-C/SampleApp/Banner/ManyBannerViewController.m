//
//  ManyBannerViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2020 fluct, Inc. All rights reserved.
//

#import "ManyBannerViewController.h"
#import <FluctSDK/FluctSDK.h>

@interface ManyBannerViewController ()
@property (nonatomic) FSSAdView *topAdView;
@property (nonatomic) FSSAdView *bottomAdView;
@end

@implementation ManyBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FSSAdView *topAdView = [[FSSAdView alloc] initWithGroupId:@"1000055927" unitId:@"1000084701" adSize:FSSAdSize320x50];
    [self.view addSubview:topAdView];
    [topAdView loadAd];
    self.topAdView = topAdView;

    FSSAdView *bottomAdView = [[FSSAdView alloc] initWithGroupId:@"1000055927" unitId:@"1000084701" adSize:FSSAdSize320x50];
    [self.view addSubview:bottomAdView];
    [bottomAdView loadAd];
    self.bottomAdView = bottomAdView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat minY = CGRectGetMinY(self.view.bounds);
    CGFloat topAdViewY = minY + self.view.layoutMargins.top;

    CGFloat maxY = CGRectGetMaxY(self.view.bounds);
    CGFloat bottomAdViewY = maxY - self.view.layoutMargins.bottom - CGRectGetHeight(self.bottomAdView.frame);

    CGFloat midX = CGRectGetMidX(self.view.bounds);
    CGFloat topAdViewX = midX - CGRectGetWidth(self.topAdView.frame) * 0.5;
    CGFloat bottomAdViewX = midX - CGRectGetWidth(self.bottomAdView.frame) * 0.5;

    CGRect topAdViewFrame = self.topAdView.frame;
    topAdViewFrame.origin = CGPointMake(topAdViewX, topAdViewY);
    self.topAdView.frame = topAdViewFrame;

    CGRect bottomAdViewFrame = self.bottomAdView.frame;
    bottomAdViewFrame.origin = CGPointMake(bottomAdViewX, bottomAdViewY);
    self.bottomAdView.frame = bottomAdViewFrame;
}

@end
