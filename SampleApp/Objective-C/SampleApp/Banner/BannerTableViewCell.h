//
//  BannerTableViewCell.h
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2016 fluct, Inc. All rights reserved.

#import <UIKit/UIKit.h>
@import FluctSDK;

@interface BannerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet FSSBannerView *banner;
@end
