//
//  FSSInAppBiddingError.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * InAppBiddingのエラーコード
 */
typedef NS_ENUM(NSInteger, FSSInAppBiddingError) {
    /** Unknown */
    FSSInAppBiddingErrorUnknown = -1,
    /** リクエストがタイムアウトした */
    FSSInAppBiddingErrorRequestTimeout = -1000,
    /** requestの情報が適切でない */
    FSSInAppBiddingErrorBadRequest = -1001,
    /** インターネットに接続されていない */
    FSSInAppBiddingErrorNotConnectedToInternet = -1002,
    /** 許可されていないアプリでリクエストを行なった */
    FSSInAppBiddingErrorInvalidApp = -1003,
    /** bidされなかった */
    FSSInAppBiddingErrorNoBid = -1004
};

extern NSString *const FSSInAppBiddingErrorSDKDomain;

NS_ASSUME_NONNULL_END
