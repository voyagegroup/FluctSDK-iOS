//
//  BannerTableViewCell.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2020 fluct, Inc. All rights reserved.

#import "BannerTableViewCell.h"
#import <FluctSDK/FluctSDK.h>

@interface BannerTableViewCell ()
@property (nonatomic, nullable) FSSAdView *adView;
@end

@implementation BannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    FSSAdView *adView = [[FSSAdView alloc] initWithGroupId:@"1000055927" unitId:@"1000084701" adSize:FSSAdSize320x50];
    [self.contentView addSubview:adView];

    [adView loadAd];
    self.adView = adView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.adView.center = self.contentView.center;
}

@end
