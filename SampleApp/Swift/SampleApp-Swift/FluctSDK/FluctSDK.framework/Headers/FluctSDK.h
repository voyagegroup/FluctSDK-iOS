//
//  FluctSDK.h
//
//  Fluct SDK
//  Copyright 2011-2014 fluct, Inc. All rights reserved.
//

/*
 * SDKの各処理を行う
 * ・広告表示設定 (表示処理はFluctBannerViewにて行われる)
 * ・コンバージョン通知処理
 */

#import "FSSAdRequestTargeting.h"
#import "FSSBannerView.h"
#import "FSSConfigurationOptions.h"
#import "FSSInterstitialView.h"
#import "FSSNativeTableViewCell.h"
#import "FSSNativeView.h"
#import "FSSRewardedVideo.h"
#import "FSSRewardedVideoCustomEvent.h"
#import "FSSRewardedVideoError.h"
#import "FSSRewardedVideoWorkQueue.h"
#import "FluctBannerView.h"
#import "FluctInterstitialView.h"
#import <UIKit/UIKit.h>

@interface FluctSDK : NSObject

@property (nonatomic, copy) NSString *applicationId;
+ (FluctSDK *)sharedInstance;

/*
 * setBannerConfiguration
 * 広告表示設定を行う
 * FluctBannerViewのインスタンス生成前にコールします
 *
 * arguments:
 * (NSString*)mediaId : メディアID
 * (NSString*)orientationType : 未使用(v2.0.0未満との互換性用)
 */
- (void)setBannerConfiguration:(NSString *)mediaId orientationType:(NSString *)orientationType;

/*
 * setBannerConfiguration
 * 広告表示設定を行う
 * FluctBannerViewのインスタンス生成前にコールします
 *
 * arguments:
 * (NSString*)mediaId : メディアID
 */
- (void)setBannerConfiguration:(NSString *)mediaId;

// Check the version of this FluctSDK
+ (NSString *)version;

+ (void)configure;
+ (void)configureWithOptions:(FSSConfigurationOptions *)options;

@end
