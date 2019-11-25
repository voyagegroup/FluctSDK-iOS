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

+ (ALSdk *)sharedWithKey:(NSString *)sdkKey;
+ (ALIncentivizedInterstitialAd *)rewardedVideoWithSdk:(ALSdk *)sdk zoneName:(nonnull NSString *)zone;

@end

static NSString *const FSSAppLovinSupportVersion = @"9.0";

@implementation FSSRewardedVideoCustomEventAppLovin

+ (ALSdk *)sharedWithKey:(NSString *)sdkKey {
    return [ALSdk sharedWithKey:sdkKey];
}

+ (ALIncentivizedInterstitialAd *)rewardedVideoWithSdk:(ALSdk *)sdk zoneName:(nonnull NSString *)zoneName {
    return [[ALIncentivizedInterstitialAd alloc] initWithZoneIdentifier:zoneName sdk:sdk];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate testMode:(BOOL)testMode debugMode:(BOOL)debugMode targeting:(FSSAdRequestTargeting *)targeting {
    if (![FSSRewardedVideoCustomEventAppLovin isOSAtLeastVersion:FSSAppLovinSupportVersion]) {
        return nil;
    }

    self = [super initWithDictionary:dictionary delegate:delegate testMode:testMode debugMode:debugMode targeting:nil];
    if (self) {
        static dispatch_once_t onceToken;
        ALSdk *applovinSDK = [FSSRewardedVideoCustomEventAppLovin sharedWithKey:dictionary[@"sdk_key"]];
        dispatch_once(&onceToken, ^{
            applovinSDK.settings.isVerboseLogging = debugMode;
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
    if ([self.rewardedVideo isReadyForDisplay]) {
        [self.rewardedVideo showAndNotify:nil];
    } else {
        // kALErrorCodeIncentiviziedAdNotPreloaded
        NSError *error = [NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain code:FSSRewardedVideoAdErrorNotReady userInfo:nil];
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                     fluctError:error
                                                 adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                    code:kALErrorCodeIncentiviziedAdNotPreloaded
                                                                                userInfo:@{NSLocalizedDescriptionKey : @"incentivizied ad not preloaded."}]];
    }
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
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        switch (code) {
        case kALErrorCodeNoFill:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorNoAds
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:code
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"no fill."}]];
            break;
        case kALErrorCodeIncentivizedValidationNetworkTimeout:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorTimeout
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:code
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"incentivized validation network timeout."}]];
            break;
        case kALErrorCodeUnableToRenderAd:
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorPlayFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:code
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"unable to render ad."}]];
            break;
        default:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorUnknown
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:code
                                                                                        userInfo:nil]];
            break;
        }
    });
}

#pragma mark ALAdDisplayDelegate

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:weakSelf];
    });
}

#pragma mark ALAdVideoPlaybackDelegate

- (void)videoPlaybackBeganInAd:(ALAd *)ad {
}

- (void)videoPlaybackEndedInAd:(ALAd *)ad atPlaybackPercent:(NSNumber *)percentPlayed fullyWatched:(BOOL)wasFullyWatched {
    if (wasFullyWatched) {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(FSSRewardedVideoWorkQueue(), ^{
            [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
        });
    }
}

@end
