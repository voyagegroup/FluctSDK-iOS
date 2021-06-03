//
//  FluctVideoInterstitialCustomEventOptimizer.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FluctVideoInterstitialCustomEventOptimizer.h"
#import "FluctCustomEventInfo.h"
#import "MoPubAdapterFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctVideoInterstitialCustomEventOptimizer () <FSSVideoInterstitialDelegate, FSSVideoInterstitialRTBDelegate, FSSVideoInterstitialCustomEventOptimizerDelegate>
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@property (nonatomic, nullable) FSSVideoInterstitialCustomEventOptimizer *optimizer;
@end

@implementation FluctVideoInterstitialCustomEventOptimizer

#pragma mark - MPFullscreenAdAdapter

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

- (BOOL)isRewardExpected {
    return NO;
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError *error;
    self.customEventInfo = [FluctCustomEventInfo customEventInfoFromMoPubInfo:info
                                                                        error:&error];
    if (error) {
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }

    if (!self.customEventInfo.pricePoint) {
        NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                             code:MoPubAdapterFluctErrorInvalidCustomParameters
                                         userInfo:nil];
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeMoPub;
    options.mediationPlatformSDKVersion = MP_SDK_VERSION;
    [FluctSDK configureWithOptions:options];

    self.optimizer = [[FSSVideoInterstitialCustomEventOptimizer alloc] initWithGroupId:self.customEventInfo.groupID
                                                                                unitId:self.customEventInfo.unitID
                                                                            pricePoint:self.customEventInfo.pricePoint];
    self.optimizer.delegate = self;

    FSSVideoInterstitialSetting *setting = FSSVideoInterstitialSetting.defaultSetting;
    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);
    [self.optimizer requestWithSetting:setting delegate:self rtbDelegate:self];
}

- (BOOL)hasAdAvailable {
    return [self.optimizer hasAdAvailable];
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    if ([self.optimizer hasAdAvailable]) {
        MPLogEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)]);
        MPLogEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)]);
        [self.optimizer presentAdFromViewController:viewController];
    }
}

#pragma mark - FSSVideoInterstitialCustomEventOptimizerDelegate

- (void)customEventNotFoundResponse:(FSSVideoInterstitialCustomEventOptimizer *)customEvent {
    NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                         code:MoPubAdapterFluctErrorNoResponse
                                     userInfo:nil];
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

#pragma mark - FSSVideoInterstitialDelegate

- (void)videoInterstitialDidLoad:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToLoadWithError:(NSError *)error {
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToPlayWithError:(NSError *)error {
    MPLogEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:error];
}

- (void)videoInterstitialWillAppear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)]);
    // TODO: willAppearはv5.17.0でいらなくなったので次のMoPubのminorアップデートで削除する（予定）
    [self.delegate fullscreenAdAdapterAdWillAppear:self];
    [self.delegate fullscreenAdAdapterAdWillPresent:self];
}

- (void)videoInterstitialDidAppear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)]);
    // TODO: didAppearはv5.17.0でいらなくなったので次のMoPubのminorアップデートで削除する（予定）
    [self.delegate fullscreenAdAdapterAdDidAppear:self];
    [self.delegate fullscreenAdAdapterAdDidPresent:self];
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterDidTrackImpression:self];
}

- (void)videoInterstitialWillDisappear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdWillDisappear:self];
    [self.delegate fullscreenAdAdapterAdWillDismiss:self];
}

- (void)videoInterstitialDidDisappear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)]);
    MPLogEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
    [self.delegate fullscreenAdAdapterAdDidDismiss:self];
}

#pragma mark - FSSVideoInterstitialRTBDelegate

- (void)videoInterstitialDidClick:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
    [self.delegate fullscreenAdAdapterDidTrackClick:self];
}

@end
