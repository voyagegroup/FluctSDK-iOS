//
//  FSSVideoInterstitialAdnetworkActivation.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FSSFullscreenVideoAdnetworkActivation.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 全画面動画広告で配信するADNWを制御する情報を保持する
 */
@interface FSSVideoInterstitialAdnetworkActivation : NSObject <FSSFullscreenVideoAdnetworkActivation>

/**
 * デフォルト
 */
@property (class, nonatomic, readonly) FSSVideoInterstitialAdnetworkActivation *defaultAdnetworkActivation NS_SWIFT_NAME(default);

/**
 * Activation setting for AdColony.
 */
@property (nonatomic, getter=isAdColonyActivated) BOOL adColonyActivated;

/**
 * Activation setting for fluct.
 */
@property (nonatomic, getter=isFluctActivated) BOOL fluctActivated;

/**
 * Activation setting for maio.
 */
@property (nonatomic, getter=isMaioActivated) BOOL maioActivated;

/**
 * Activation setting for Tapjoy.
 */
@property (nonatomic, getter=isTapjoyActivated) BOOL tapjoyActivated;

/**
 * Activation setting for UnityAds.
 */
@property (nonatomic, getter=isUnityAdsActivated) BOOL unityAdsActivated;

/**
 * 設定されている情報を文字列にして出力する
 */
- (NSString *)description;

/**
 * 配信不可設定にしているADNWがあるかどうかを返す
 * @return 1つでも配信不可にしている場合はYES、それ以外はNO
 */
- (BOOL)hasDeactivatedAdnetwork;

@end

NS_ASSUME_NONNULL_END
