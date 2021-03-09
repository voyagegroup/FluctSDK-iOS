//
//  FluctSDK.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// In this header, you should import all the public headers of your framework using statements like #import <FluctSDK/PublicHeader.h>
#import <FluctSDK/FSSRewardedVideo.h>
#import <FluctSDK/FSSRewardedVideoAdnetworkActivation.h>
#import <FluctSDK/FSSRewardedVideoCustomEvent.h>
#import <FluctSDK/FSSRewardedVideoError.h>
#import <FluctSDK/FSSRewardedVideoRTBDelegate.h>
#import <FluctSDK/FSSRewardedVideoSetting.h>

#import <FluctSDK/FSSAdRequestTargeting.h>
#import <FluctSDK/FSSConfigurationOptions.h>

#import <FluctSDK/FSSAdView.h>
#import <FluctSDK/FSSAdViewError.h>

#import <FluctSDK/FSSFullscreenVideoWorkQueue.h>

#import <FluctSDK/FSSVideoError.h>

#import <FluctSDK/FSSVideoInterstitial.h>
#import <FluctSDK/FSSVideoInterstitialAdnetworkActivation.h>
#import <FluctSDK/FSSVideoInterstitialRTBDelegate.h>
#import <FluctSDK/FSSVideoInterstitialSetting.h>

#import <FluctSDK/FSSInAppBidding.h>
#import <FluctSDK/FSSInAppBiddingBannerResponseCache.h>
#import <FluctSDK/FSSInAppBiddingError.h>
#import <FluctSDK/FSSInAppBiddingFullscreenVideoResponseCache.h>

#import <FluctSDK/FSSBannerCustomEventOptimizer.h>
#import <FluctSDK/FSSBannerCustomEventStarter.h>
#import <FluctSDK/FSSRewardedVideoCustomEventOptimizer.h>
#import <FluctSDK/FSSRewardedVideoCustomEventStarter.h>
#import <FluctSDK/FSSVideoInterstitialCustomEventOptimizer.h>
#import <FluctSDK/FSSVideoInterstitialCustomEventStarter.h>

#import <FluctSDK/FSSConditionObserver.h>

/*
 * SDKの各処理を行う
 * ・広告表示設定 (表示処理はFluctBannerViewにて行われる)
 * ・コンバージョン通知処理
 */

NS_ASSUME_NONNULL_BEGIN

/**
 * FluctSDK共通クラス
 */
@interface FluctSDK : NSObject

/**
 * FluctSDKクラスのインスタンス
 */
@property (class, nonatomic, readonly) FluctSDK *sharedInstance NS_SWIFT_NAME(shared);

/**
 * FluctSDKのバージョン番号を返す。
 * @return バージョン番号
 */
+ (NSString *)version;

/**
 * FluctSDKの設定を行う。
 */
+ (void)configure;

/**
 * FluctSDKの設定を行う。
 * @param options 設定オプション
 */
+ (void)configureWithOptions:(FSSConfigurationOptions *)options;

/**
 * 現在の設定オプションを返す。
 * @return 現在の設定オプション
 */
+ (FSSConfigurationOptions *)currentConfigureOptions;
@end

NS_ASSUME_NONNULL_END
