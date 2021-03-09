//
//  FSSVideoError.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 動画広告のエラーコード
 */
typedef NS_ENUM(NSInteger, FSSVideoError) {
    /** Unknown */
    FSSVideoErrorUnknown = -1,
    /** 広告リクエストがタイムアウトした */
    FSSVideoErrorTimeout = -1000,
    /** SDKの初期化に失敗 */
    FSSVideoErrorInitializeFailed = -1001,
    /** 動画広告の読み込みに失敗 */
    FSSVideoErrorLoadFailed = -1002,
    /** 動画広告の再生準備が完了してない */
    FSSVideoErrorNotReady = -1003,
    /** 動画広告の在庫がない */
    FSSVideoErrorNoAds = -1004,
    /** requestの情報が適切でない */
    FSSVideoErrorBadRequest = -1005,
    /** 動画広告の再生に失敗 */
    FSSVideoErrorPlayFailed = -1006,
    /** 広告枠の設定に問題がある */
    FSSVideoErrorWrongConfiguration = -1007,
    /** インターネットに接続されていない */
    FSSVideoErrorNotConnectedToInternet = -1008,
    /** 動画広告の有効期限切れ */
    FSSVideoErrorExpired = -1009,
    /** VASTのparseに失敗 */
    FSSVideoErrorVastParseFailed = -1010,
    /** 許可されていないアプリでリクエストを行なった */
    FSSVideoErrorInvalidApp = -1011,
};

extern NSString *const FSSVideoErrorSDKDomain;

NS_ASSUME_NONNULL_END
