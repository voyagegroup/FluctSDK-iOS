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

/**
 * CustomEvent側でimpressionとclickを計測したいので
 * NOを返す
 */
- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError *error;
    self.customEventInfo = [FluctCustomEventInfo customEventInfoFromMoPubInfo:info
                                                                        error:&error];
    if (error) {
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
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

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    MPLogEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)]);
    MPLogEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)]);
    [self.interstitial presentAdFromViewController:rootViewController];
}

#pragma mark - FSSVideoInterstitialDelegate

- (void)videoInterstitialDidLoad:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEvent:self didLoadAd:interstitial];
}

- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToLoadWithError:(NSError *)error {
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToPlayWithError:(NSError *)error {
    MPLogEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error]);
}

- (void)videoInterstitialWillAppear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEventWillAppear:self];
}

- (void)videoInterstitialDidAppear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEventDidAppear:self];
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);

    // 表示できたらimp
    [self.delegate trackImpression];
}

- (void)videoInterstitialWillDisappear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEventWillDisappear:self];
}

- (void)videoInterstitialDidDisappear:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEventDidDisappear:self];
    MPLogEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)]);
}

#pragma mark - FSSVideoInterstitialRTBDelegate

- (void)videoInterstitialDidClick:(FSSVideoInterstitial *)interstitial {
    MPLogEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate trackClick];
}

@end
