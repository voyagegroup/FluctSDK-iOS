//
//  FSSRewardedVideoCustomEvent.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FSSRewardedVideoCustomEventDelegate;

typedef NS_ENUM(NSInteger, FSSRewardedVideoADNWStatus) {
    FSSRewardedVideoADNWStatusNotLoaded,
    FSSRewardedVideoADNWStatusLoading,
    FSSRewardedVideoADNWStatusLoaded,
    FSSRewardedVideoADNWStatusNotDisplayable
};

@interface FSSRewardedVideoCustomEvent : NSObject {
    FSSRewardedVideoADNWStatus _adnwStatus;
}

@property (nonatomic, weak) id<FSSRewardedVideoCustomEventDelegate> delegate;
@property (nonatomic, readonly) BOOL testMode;
@property (nonatomic, readonly) BOOL debugMode;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode;

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary;
- (FSSRewardedVideoADNWStatus)loadStatus;
- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController;
- (NSString *)sdkVersion;
- (void)invalidate;
@end

@protocol FSSRewardedVideoCustomEventDelegate <NSObject>
- (void)rewardedVideoShouldRewardForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoDidLoadForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoDidFailToLoadForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent fluctError:(NSError *)fluctError adnetworkError:(NSInteger)adnetworkError;
- (void)rewardedVideoWillAppearForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoDidAppearForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoWillDisappearForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoDidDisappearForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
- (void)rewardedVideoDidFailToPlayForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent fluctError:(NSError *)fluctError adnetworkError:(NSInteger)adnetworkError;
- (void)rewardedVideoDidClickForCustomEvent:(FSSRewardedVideoCustomEvent *)customEvent;
@end
