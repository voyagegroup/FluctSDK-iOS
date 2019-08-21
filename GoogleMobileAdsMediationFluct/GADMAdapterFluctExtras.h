//
//  GADMAdapterFluctExtras.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMobileAds;
@import FluctSDK;

NS_ASSUME_NONNULL_BEGIN

@interface GADMAdapterFluctExtras : NSObject <GADAdNetworkExtras>

@property (nonatomic, nullable) FSSRewardedVideoSetting *setting;
@property (nonatomic, nullable) FSSAdRequestTargeting *targeting;

@end

NS_ASSUME_NONNULL_END
