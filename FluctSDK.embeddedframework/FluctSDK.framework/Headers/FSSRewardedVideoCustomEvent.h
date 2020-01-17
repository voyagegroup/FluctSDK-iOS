//
//  FSSRewardedVideoCustomEvent.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSAdRequestTargeting.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FSSRewardedVideoCustomEventDelegate;

typedef NS_ENUM(NSInteger, FSSRewardedVideoADNWStatus) {
    FSSRewardedVideoADNWStatusNotLoaded,
    FSSRewardedVideoADNWStatusLoading,
    FSSRewardedVideoADNWStatusLoaded,
    FSSRewardedVideoADNWStatusNotDisplayable
};

@interface FSSRewardedVideoCustomEvent : NSObject

@property (nonatomic, weak) id<FSSRewardedVideoCustomEventDelegate> delegate;
@property (nonatomic, readonly) BOOL testMode;
@property (nonatomic, readonly) BOOL debugMode;
@property (nonatomic, readonly, getter=isSkippable) BOOL skippable;
@property (nonatomic) FSSRewardedVideoADNWStatus adnwStatus;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting;

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary;
- (FSSRewardedVideoADNWStatus)loadStatus;
- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController;
- (NSString *)sdkVersion;
- (void)invalidate;
+ (BOOL)isOSAtLeastVersion:(NSString *)version;
@end

@protocol FSSRewardedVideoCustomEventDelegate <NSObject>
- (void)rewardedVideoShouldRewardForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoDidLoadForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoDidFailToLoadForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent fluctError:(NSError *)fluctError adnetworkError:(NSError *)adnetworkError;
- (void)rewardedVideoWillAppearForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoDidAppearForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoWillDisappearForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoDidDisappearForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoDidFailToPlayForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent fluctError:(NSError *)fluctError adnetworkError:(NSError *)adnetworkError;
- (void)rewardedVideoDidClickForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
@end
