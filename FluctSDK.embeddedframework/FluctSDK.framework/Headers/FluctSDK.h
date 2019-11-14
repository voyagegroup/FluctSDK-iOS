//
//  FluctSDK.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for FluctSDK.
FOUNDATION_EXPORT double FluctSDKVersionNumber;

//! Project version string for FluctSDK.
FOUNDATION_EXPORT const unsigned char FluctSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FluctSDK/PublicHeader.h>
#import <FluctSDK/FSSBannerView.h>
#import <FluctSDK/FSSInterstitialView.h>

#import <FluctSDK/FSSNativeTableViewCell.h>
#import <FluctSDK/FSSNativeView.h>

#import <FluctSDK/FSSRewardedVideo.h>
#import <FluctSDK/FSSRewardedVideoAdnetworkActivation.h>
#import <FluctSDK/FSSRewardedVideoCustomEvent.h>
#import <FluctSDK/FSSRewardedVideoError.h>
#import <FluctSDK/FSSRewardedVideoSetting.h>
#import <FluctSDK/FSSRewardedVideoWorkQueue.h>

#import <FluctSDK/FSSAdRequestTargeting.h>
#import <FluctSDK/FSSConfigurationOptions.h>

#import <FluctSDK/FSSAdView.h>
#import <FluctSDK/FSSAdViewError.h>

/*
 * SDKの各処理を行う
 * ・広告表示設定 (表示処理はFluctBannerViewにて行われる)
 * ・コンバージョン通知処理
 */

NS_ASSUME_NONNULL_BEGIN

@interface FluctSDK : NSObject

@property (class, nonatomic, readonly) FluctSDK *sharedInstance NS_SWIFT_NAME(shared);
@property (nonatomic, copy, nullable) NSString *applicationId;

/*
 * setBannerConfiguration
 * 広告表示設定を行う
 * FluctBannerViewのインスタンス生成前にコールします
 *
 * arguments:
 * (NSString*)mediaId : メディアID
 * (NSString*)orientationType : 未使用(v2.0.0未満との互換性用)
 */
- (void)setBannerConfiguration:(NSString *)mediaId orientationType:(NSString *_Nullable)orientationType;

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
+ (FSSConfigurationOptions *)currentConfigureOptions;

@end

NS_ASSUME_NONNULL_END
