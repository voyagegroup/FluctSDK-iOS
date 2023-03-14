//
//  FSSRewardedVideoError.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

__attribute__((deprecated("No longer supported; please adopt FSSVideoError."))) typedef NS_ENUM(NSInteger, FSSRewardedVideoErrorCode) {
    FSSRewardedVideoAdErrorUnknown __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorUnknown."))) = -1,
    FSSRewardedVideoAdErrorTimeout __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorTimeout."))) = -1000,
    FSSRewardedVideoAdErrorInitializeFailed __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorInitializeFailed."))) = -1001,
    FSSRewardedVideoAdErrorLoadFailed __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorLoadFailed."))) = -1002,
    FSSRewardedVideoAdErrorNotReady __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorNotReady."))) = -1003,
    FSSRewardedVideoAdErrorNoAds __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorNoAds."))) = -1004,
    FSSRewardedVideoAdErrorBadRequest __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorBadRequest."))) = -1005,
    FSSRewardedVideoAdErrorPlayFailed __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorPlayFailed."))) = -1006,
    FSSRewardedVideoAdErrorWrongConfiguration __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorWrongConfiguration."))) = -1007,
    FSSRewardedVideoAdErrorNotConnectedToInternet __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorNotConnectedToInternet."))) = -1008,
    FSSRewardedVideoAdErrorExpired __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorExpired."))) = -1009,
    FSSRewardedVideoAdErrorVastParseFailed __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorVastParseFailed."))) = -1010,
    FSSRewardedVideoAdErrorInvalidApp __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorInvalidApp."))) = -1011,
};

extern NSString *const FSSRewardedVideoAdsSDKDomain __attribute__((deprecated("No longer supported; please adopt FSSVideoErrorSDKDomain.")));
