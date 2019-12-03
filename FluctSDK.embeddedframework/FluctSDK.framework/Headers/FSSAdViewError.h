//
//  FSSAdViewError.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * FSSAdViewのエラー
 */
typedef NS_ENUM(NSInteger, FSSAdViewError) {
    /**
     * Unknown error
     */
    FSSAdViewErrorUnknown = -2,
    /**
     * ネットーワークエラー
     */
    FSSAdViewErrorNotConnectedToInternet = -2001,
    /**
     * サーバーエラー
     */
    FSSAdViewErrorServerError = -2002,
    /**
     * 広告在庫が存在しないことを表すエラー
     */
    FSSAdViewErrorNoAds = -2003,
    /**
     * グループID、ユニットID、バンドルの不正を表すエラー
     */
    FSSAdViewErrorBadRequest = -2004,
};

extern NSString *const FSSBannerAdsSDKDomain;
