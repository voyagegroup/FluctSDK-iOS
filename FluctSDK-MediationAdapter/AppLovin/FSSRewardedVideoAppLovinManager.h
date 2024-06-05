//
//  FSSRewardedVideoAppLovinManager.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSAppLovin.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import <FluctSDK/FluctSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AppLovinFailReasonExtend) {
    AppLovinFailReasonExtendLoadFailed = -1,
};

@protocol FSSRewardedVideoAppLovinManagerDelegate <ALAdLoadDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate>
- (void)appLovinFailedToInitializeWithFluctError:(NSError *)fluctError
                                  adnetworkError:(NSError *)adnetworkError;
@end

@interface FSSRewardedVideoAppLovinManager : NSObject
+ (instancetype)sharedInstance;
- (void)loadRewardedVideoWithSdkKey:(NSString *)sdkKey
                           zoneName:(NSString *)zoneName
                           appLovin:(id<FSSAppLovinProtocol>)appLovin
                           delegate:(id<FSSRewardedVideoAppLovinManagerDelegate>)delegate
                           testMode:(BOOL)testMode;
@end
NS_ASSUME_NONNULL_END
