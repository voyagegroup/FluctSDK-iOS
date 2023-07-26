//
//  FSSRewardedVideoCustomEventAppLovin.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventAppLovin.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface FSSRewardedVideoCustomEventAppLovin () <ALAdLoadDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate>

@property (nonatomic) ALIncentivizedInterstitialAd *rewardedVideo;

@property (nonatomic) FSSConditionObserver *observer;

+ (ALSdk *)sharedWithKey:(NSString *)sdkKey;
+ (ALIncentivizedInterstitialAd *)rewardedVideoWithSdk:(ALSdk *)sdk zoneName:(nonnull NSString *)zone;

@end

@implementation FSSRewardedVideoCustomEventAppLovin

+ (ALSdk *)sharedWithKey:(NSString *)sdkKey {
    return [ALSdk sharedWithKey:sdkKey];
}

+ (ALIncentivizedInterstitialAd *)rewardedVideoWithSdk:(ALSdk *)sdk zoneName:(nonnull NSString *)zoneName {
    return [[ALIncentivizedInterstitialAd alloc] initWithZoneIdentifier:zoneName sdk:sdk];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting {
    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:nil];
    if (self) {
        static dispatch_once_t onceToken;
        ALSdk *applovinSDK = [FSSRewardedVideoCustomEventAppLovin sharedWithKey:dictionary[@"sdk_key"]];
        dispatch_once(&onceToken, ^{
            applovinSDK.settings.verboseLoggingEnabled = debugMode;
            [applovinSDK initializeSdk];
        });
        _rewardedVideo = [FSSRewardedVideoCustomEventAppLovin rewardedVideoWithSdk:applovinSDK zoneName:dictionary[@"zone"]];
        _rewardedVideo.adDisplayDelegate = self;
        _rewardedVideo.adVideoPlaybackDelegate = self;
    }
    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    if ([self.rewardedVideo isReadyForDisplay]) {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [self.delegate rewardedVideoDidLoadForCustomEvent:self];
    } else {
        [self.rewardedVideo preloadAndNotify:self];
        self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    }
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    if (![self.rewardedVideo isReadyForDisplay]) {
        // kALErrorCodeIncentiviziedAdNotPreloaded
        NSError *error = [NSError errorWithDomain:FSSVideoErrorSDKDomain code:FSSVideoErrorNotReady userInfo:nil];
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                     fluctError:error
                                                 adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                    code:kALErrorCodeIncentiviziedAdNotPreloaded
                                                                                userInfo:@{NSLocalizedDescriptionKey : @"incentivizied ad not preloaded."}]];
        return;
    }

    [self.rewardedVideo showAndNotify:nil];

    __weak __typeof(self) weakSelf = self;
    // wasHiddenInが呼ばれた時、最前面にALAppLovinVideoViewControllerが残っているので完全に消えるまで遅延させる
    self.observer = [[FSSConditionObserver alloc] initWithInterval:0.1f
        fallbackLimit:20
        completionHandler:^{
            dispatch_async(FSSWorkQueue(), ^{
                [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
            });
        }
        fallbackHandler:^{
            dispatch_async(FSSWorkQueue(), ^{
                NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                          code:FSSVideoErrorUnknown
                                                      userInfo:@{NSLocalizedDescriptionKey : @"Failed callback for rewardedVideoDidDisappearForCustomEvent"}];
                [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                                 fluctError:fluctError
                                                             adnetworkError:fluctError];
            });
        }
        shouldCompletionCondition:^BOOL {
            return !viewController.presentedViewController;
        }];
}

- (NSString *)sdkVersion {
    return [ALSdk version];
}

- (void)invalidate {
    self.rewardedVideo = nil;
}

#pragma mark ALAdLoadDelegate

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        switch (code) {
        case kALErrorCodeNoFill:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorNoAds
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:code
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"no fill."}]];
            break;
        case kALErrorCodeIncentivizedValidationNetworkTimeout:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorTimeout
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:code
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"incentivized validation network timeout."}]];
            break;
        case kALErrorCodeUnableToRenderAd:
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorPlayFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:code
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"unable to render ad."}]];
            break;
        default:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorUnknown
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:code
                                                                                        userInfo:nil]];
            break;
        }
    });
}

#pragma mark ALAdDisplayDelegate

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
    });

    [self.observer start];
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:weakSelf];
    });
}

#pragma mark ALAdVideoPlaybackDelegate

- (void)videoPlaybackBeganInAd:(ALAd *)ad {
}

- (void)videoPlaybackEndedInAd:(ALAd *)ad atPlaybackPercent:(NSNumber *)percentPlayed fullyWatched:(BOOL)wasFullyWatched {
    if (wasFullyWatched) {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(FSSWorkQueue(), ^{
            [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
        });
    }
}

@end
