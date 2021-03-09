//
//  FSSInAppBidding.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * InAppBiddingが対応している広告フォーマット
 */
typedef NS_ENUM(NSUInteger, FSSInAppBiddingAdFormat) {
    /**
     * 動画リワード
     */
    FSSInAppBiddingAdFormatRewardedVideo = 0,
    /**
     * 動画インタースティシャル
     */
    FSSInAppBiddingAdFormatVideoInterstitial,
    /**
     * バナー
     */
    FSSInAppBiddingAdFormatBanner
};

/**
 * InAppBiddingのレスポンス
 */
@interface FSSInAppBiddingResponse : NSObject

/**
 * biddingした結果の値
 */
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> *value;

@end

/**
 * requestした結果のcallback
 * @param response  bidされた時の情報
 * @param error     エラー情報
 */
typedef void (^FSSInAppBiddingCompletionBlock)(FSSInAppBiddingResponse *_Nullable response, NSError *_Nullable error);

/**
 * biddingするクラス
 */
@interface FSSInAppBidding : NSObject

/**
 * グループID
 */
@property (nonatomic, readonly) NSString *groupId;

/**
 * ユニットID
 */
@property (nonatomic, readonly) NSString *unitId;

/**
 * 広告フォーマット
 */
@property (nonatomic, readonly) FSSInAppBiddingAdFormat adFormat;

/**
 * デバッグモード
 */
@property (nonatomic, readonly, getter=isDebugMode) BOOL debugMode;

/**
 * FSSInAppBiddingの初期化を行う
 * @param groupId   グループID
 * @param unitId    ユニットID
 * @param adFormat  広告フォーマット
 */
- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId adFormat:(FSSInAppBiddingAdFormat)adFormat;

/**
 * FSSInAppBiddingの初期化を行う
 * @param groupId   グループID
 * @param unitId    ユニットID
 * @param adFormat  広告フォーマット
 * @param debugMode デバッグモード
 */
- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId adFormat:(FSSInAppBiddingAdFormat)adFormat debugMode:(BOOL)debugMode;

/**
 * リクエストする
 * @param completion    リクエスト処理が完了した時にcallされるblock
 */
- (void)requestWithCompletion:(FSSInAppBiddingCompletionBlock)completion;

/**
 * リクエストする
 * @param adSize        広告描画領域
 * @param completion    リクエスト処理が完了した時にcallされるblock
 */
- (void)requestWithAdSize:(CGSize)adSize completion:(FSSInAppBiddingCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
