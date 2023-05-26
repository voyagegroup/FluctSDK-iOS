//
//  GADMAdapterFluctRewardedAd.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMobileAds;

NS_ASSUME_NONNULL_BEGIN

@interface GADMAdapterFluctRewardedAd : NSObject <GADMediationRewardedAd>

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
