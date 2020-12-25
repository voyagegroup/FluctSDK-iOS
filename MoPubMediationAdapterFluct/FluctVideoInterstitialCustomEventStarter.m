//
//  FluctVideoInterstitialCustomEventStarter.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FluctVideoInterstitialCustomEventStarter.h"
#import "FluctCustomEventInfo.h"
#import "MoPubAdapterFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctVideoInterstitialCustomEventStarter () <FSSVideoInterstitialDelegate, FSSVideoInterstitialRTBDelegate, FSSVideoInterstitialCustomEventStarterDelegate>
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@property (nonatomic, nullable) FSSVideoInterstitialCustomEventStarter *starter;
@end

@implementation FluctVideoInterstitialCustomEventStarter

/**
 * clickとimpressionを手動でtracking
 */
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

    self.starter = [[FSSVideoInterstitialCustomEventStarter alloc] initWithGroupId:self.customEventInfo.groupID
                                                                            unitId:self.customEventInfo.unitID
                                                                        pricePoint:self.customEventInfo.pricePoint];
    self.starter.delegate = self;

    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);
    FSSVideoInterstitialSetting *setting = FSSVideoInterstitialSetting.defaultSetting;
    [self.starter requestWithSetting:setting delegate:self rtbDelegate:self];
}

- (BOOL)hasAdAvailable {
    return [self.starter hasAdAvailable];
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    if ([self.starter hasAdAvailable]) {
        MPLogEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)]);
        MPLogEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)]);
        [self.starter presentAdFromViewController:viewController];
    }
}

#pragma mark - FSSVideoInterstitialCustomEventStarterDelegate

- (void)customEventNotFoundResponse:(FSSVideoInterstitialCustomEventStarter *)customEvent {
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
    [self.delegate fullscreenAdAdapterAdWillAppear:self];
}

- (void)videoInterstitialDidAppear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdDidAppear:self];
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterDidTrackImpression:self];
}

- (void)videoInterstitialWillDisappear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdWillDisappear:self];

    // `fullscreenAdAdapterAdWillDismiss:` was introduced in MoPub SDK 5.15.0.
    if ([self.delegate respondsToSelector:@selector(fullscreenAdAdapterAdWillDismiss:)]) {
        [self.delegate fullscreenAdAdapterAdWillDismiss:self];
    }
}

- (void)videoInterstitialDidDisappear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
    MPLogEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)]);

    // Signal that the fullscreen ad is closing and the state should be reset.
    // `fullscreenAdAdapterAdDidDismiss:` was introduced in MoPub SDK 5.15.0.
    if ([self.delegate respondsToSelector:@selector(fullscreenAdAdapterAdDidDismiss:)]) {
        [self.delegate fullscreenAdAdapterAdDidDismiss:self];
    }
}

#pragma mark - FSSVideoInterstitialRTBDelegate

- (void)videoInterstitialDidClick:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
    [self.delegate fullscreenAdAdapterDidTrackClick:self];
}

@end
