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

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError *error;
    self.customEventInfo = [FluctCustomEventInfo customEventInfoFromMoPubInfo:info
                                                                        error:&error];
    if (error) {
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
        return;
    }

    if (!self.customEventInfo.pricePoint) {
        NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                             code:MoPubAdapterFluctErrorInvalidCustomParameters
                                         userInfo:nil];
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
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

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    if ([self.starter hasAdAvailable]) {
        MPLogEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)]);
        MPLogEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)]);
        [self.starter presentAdFromViewController:rootViewController];
    }
}

#pragma mark - FSSVideoInterstitialCustomEventStarterDelegate

- (void)customEventNotFoundResponse:(FSSVideoInterstitialCustomEventStarter *)customEvent {
    NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                         code:MoPubAdapterFluctErrorNoResponse
                                     userInfo:nil];
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
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
