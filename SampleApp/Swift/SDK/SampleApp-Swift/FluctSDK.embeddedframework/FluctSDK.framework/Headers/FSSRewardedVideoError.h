//
//  FSSRewardedVideoError.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FSSRewardedVideoErrorCode) {
    FSSRewardedVideoAdErrorUnknown = -1,

    FSSRewardedVideoAdErrorTimeout = -1000,
    FSSRewardedVideoAdErrorInitializeFailed = -1001,
    FSSRewardedVideoAdErrorLoadFailed = -1002,
    FSSRewardedVideoAdErrorNotReady = -1003,
    FSSRewardedVideoAdErrorNoAds = -1004,
    FSSRewardedVideoAdErrorBadRequest = -1005,
    FSSRewardedVideoAdErrorPlayFailed = -1006,
    FSSRewardedVideoAdErrorWrongConfiguration = -1007,
    FSSRewardedVideoAdErrorNotConnectedToInternet = -1008,
    FSSRewardedVideoAdErrorExpired = -1009,
    FSSRewardedVideoAdErrorVastParseFailed = -1010,
    FSSRewardedVideoAdErrorInvalidApp = -1011,
};

extern NSString *const FSSRewardedVideoAdsSDKDomain;
