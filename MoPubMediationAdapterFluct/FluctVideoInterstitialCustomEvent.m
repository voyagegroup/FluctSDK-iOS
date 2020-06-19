//
//  FluctVideoInterstitialCustomEvent.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FluctVideoInterstitialCustomEvent.h"
#import "FluctCustomEventInfo.h"
#import "FluctRewardedVideoDelegateRouter.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctVideoInterstitialCustomEvent () <FSSVideoInterstitialDelegate, FSSVideoInterstitialRTBDelegate>
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@property (nonatomic, nullable) FSSVideoInterstitial *interstitial;
@end

@implementation FluctVideoInterstitialCustomEvent

#pragma mark - MPFullscreenAdapter Override

- (void)dealloc {
    self.interstitial.delegate = nil;
    self.interstitial = nil;
}

- (BOOL)isRewardExpected {
    return NO;
}

- (BOOL)enableAutomaticImpressionAndClickTracking {
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

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeMoPub;
    options.mediationPlatformSDKVersion = MP_SDK_VERSION;
    [FluctSDK configureWithOptions:options];

    FSSVideoInterstitialSetting *setting = FSSVideoInterstitialSetting.defaultSetting;
    self.interstitial = [[FSSVideoInterstitial alloc] initWithGroupId:self.customEventInfo.groupID
                                                               unitId:self.customEventInfo.unitID
                                                              setting:setting];
    self.interstitial.delegate = self;
    self.interstitial.rtbDelegate = self;

    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);

    [self.interstitial loadAd];
}

- (BOOL)hasAdAvailable {
    return [self.interstitial hasAdAvailable];
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    MPLogEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)]);
    MPLogEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)]);
    [self.interstitial presentAdFromViewController:viewController];
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
}

- (void)videoInterstitialDidDisappear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
    MPLogEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)]);
}

#pragma mark - FSSVideoInterstitialRTBDelegate

- (void)videoInterstitialDidClick:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
    [self.delegate fullscreenAdAdapterDidTrackClick:self];
}

@end
