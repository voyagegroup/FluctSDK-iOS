//
//  FSSNativeAdError.h
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FSSNativeAdError) {
    /** Unknown */
    FSSNativeAdErrorUnknown = -3,
    /** ネットワークエラー */
    FSSNativeAdErrorNotConnectedToInternet = -3001,
    /** サーバーエラー */
    FSSNativeAdErrorServerError = -3002,
    /** 広告在庫が存在しない */
    FSSNativeAdErrorNoAds = -3003,
    /** グループID、ユニットID、バンドルの不正 */
    FSSNativeAdErrorBadRequest = -3004,
};

extern NSString *const FSSNativeAdErrorSDKDomain;

NS_ASSUME_NONNULL_END
