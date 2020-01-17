//
//  FSSRewardedVideoSetting.h
//  FluctSDK
//
//  Copyright © 2019年 fluct, Inc. All rights reserved.
//

#import "FSSFullscreenVideoSetting.h"
#import "FSSRewardedVideoAdnetworkActivation.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSSRewardedVideoSetting : NSObject <FSSFullscreenVideoSetting>

@property (class, nonatomic, readonly) FSSRewardedVideoSetting *defaultSetting NS_SWIFT_NAME(default);

/**
 * Settings for each adnetwork activation.
 */
@property (nonatomic) FSSRewardedVideoAdnetworkActivation *activation;

/**
 * Setting for debug mode.
 */
@property (nonatomic, getter=isDebugMode) BOOL debugMode;

/**
 * Setting for test mode.
 */
@property (nonatomic, getter=isTestMode) BOOL testMode;

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
