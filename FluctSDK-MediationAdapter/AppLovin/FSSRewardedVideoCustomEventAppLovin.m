//
//  FSSRewardedVideoCustomEventAppLovin.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventAppLovin.h"
#import "FSSAppLovin.h"
#import "FSSRewardedVideoAppLovinManager.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface FSSRewardedVideoCustomEventAppLovin () <FSSRewardedVideoAppLovinManagerDelegate, ALAdLoadDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate>

@property (nonatomic) id<FSSAppLovinProtocol> appLovin;
@property (nonatomic, copy) NSString *zoneName;
@property (nonatomic, copy) NSString *sdkKey;
@property (nonatomic) FSSRewardedVideoAppLovinManager *appLovinManager;
@property (nonatomic) FSSConditionObserver *observer;

@end

@implementation FSSRewardedVideoCustomEventAppLovin

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                           setting:(id<FSSFullscreenVideoSetting>)setting {
    return [self initWithDictionary:dictionary
                           delegate:delegate
                           testMode:testMode
                          debugMode:debugMode
                          skippable:skippable
                          targeting:nil
                            setting:setting
                           appLovin:[FSSAppLovin new]
                    appLovinManager:[FSSRewardedVideoAppLovinManager sharedInstance]];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                           setting:(id<FSSFullscreenVideoSetting>)setting
                          appLovin:(id<FSSAppLovinProtocol>)appLovin
                   appLovinManager:(FSSRewardedVideoAppLovinManager *)appLovinManager {
    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:nil
                             setting:setting];

    self.zoneName = dictionary[@"zone"];
    self.sdkKey = dictionary[@"sdk_key"];
    self.appLovin = appLovin;
    self.appLovinManager = appLovinManager;

    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    if ([self.appLovin isReadyForDisplay]) {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [self.delegate rewardedVideoDidLoadForCustomEvent:self];
    } else {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
        [self.appLovinManager loadRewardedVideoWithSdkKey:self.sdkKey
                                                 zoneName:self.zoneName
                                                 appLovin:self.appLovin
                                                 delegate:self
                                                 testMode:self.testMode];
    }
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    if (![self.appLovin isReadyForDisplay]) {
        self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        NSError *error = [NSError errorWithDomain:FSSVideoErrorSDKDomain code:FSSVideoErrorNotReady userInfo:nil];
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                     fluctError:error
                                                 adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                    code:kALErrorCodeIncentiviziedAdNotPreloaded
                                                                                userInfo:@{NSLocalizedDescriptionKey : @"incentivizied ad not preloaded."}]];
        return;
    }

    [self.appLovin show];

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
    self.appLovin = nil;
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

#pragma mark FSSRewardedVideoAppLovinManagerDelegate

- (void)appLovinLoad:(id<FSSAppLovinProtocol>)ad {
    self.appLovin = ad;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)appLovinFailedToInitializeWithFluctError:(nonnull NSError *)fluctError adnetworkError:(nonnull NSError *)adnetworkError {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:fluctError
                                                     adnetworkError:adnetworkError];
    });
}

@end
