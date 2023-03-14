//
//  FSSVideoInterstitialSetting.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FSSFullscreenVideoSetting.h"
#import "FSSVideoInterstitialAdnetworkActivation.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * FSSVideoInterstitialの広告配信設定情報を保持する
 */
@interface FSSVideoInterstitialSetting : NSObject <FSSFullscreenVideoSetting>

/**
 * デフォルトセッティング
 */
@property (class, nonatomic, readonly) FSSVideoInterstitialSetting *defaultSetting NS_SWIFT_NAME(default);

/**
 * Settings for each adnetwork activation.
 */
@property (nonatomic) FSSVideoInterstitialAdnetworkActivation *activation;

/**
 * Setting for debug mode.
 */
@property (nonatomic, getter=isDebugMode) BOOL debugMode;

/**
 * Setting for test mode.
 */
@property (nonatomic, getter=isTestMode) BOOL testMode;

/**
 * 設定されている情報を文字列にして出力する
 */
- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
