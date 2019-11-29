//
//  FluctBannerCustomEvent.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FluctBannerCustomEvent.h"
#import "FluctCustomEventInfo.h"
#import "MoPubAdapterFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctBannerCustomEvent () <FSSAdViewDelegate, FSSAdViewCustomEventDelegate>
@property (nonatomic, strong) FSSAdView *adView;
@end

@implementation FluctBannerCustomEvent

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError *error;
    FluctCustomEventInfo *customEventInfo = [FluctCustomEventInfo customEventInfoFromMoPubInfo:info
                                                                                         error:&error];
    if (error) {
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
        return;
    }

    FSSAdSize adSize = {CGSizeZero};
    switch (customEventInfo.adunitFormat) {
    case FluctAdUnitFormatBanner:
        adSize = FSSAdSize320x50;
        break;
    case FluctAdUnitFormatMediumRectangle:
        adSize = FSSAdSize300x250;
        break;
    default:
        break;
    }

    if (CGSizeEqualToSize(adSize.size, CGSizeZero)) {
        error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                    code:MoPubAdapterFluctErrorInvalidAdSize
                                userInfo:@{NSLocalizedDescriptionKey : @"invalid ad unit format"}];
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
        return;
    }

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeMoPub;
    options.mediationPlatformSDKVersion = MP_SDK_VERSION;
    [FluctSDK configureWithOptions:options];

    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);

    self.adView = [[FSSAdView alloc] initWithGroupId:customEventInfo.groupID unitId:customEventInfo.unitID adSize:adSize];
    self.adView.delegate = self;
    self.adView.customEventDelegate = self;
    [self.adView loadAd];
}

#pragma mark - FSSAdViewDelegate

- (void)adViewDidStoreAd:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);
}

- (void)adView:(FSSAdView *)adView didFailToStoreAdWithError:(NSError *)error {
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
    [self.adView removeFromSuperview];
    self.adView = nil;
}

- (void)willLeaveApplicationForAdView:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)]);
    [self.delegate bannerCustomEventWillBeginAction:self];
    [self.delegate bannerCustomEventWillLeaveApplication:self];
    [self.delegate bannerCustomEventDidFinishAction:self];
}

#pragma mark - FSSAdViewCustomEventDelegate

- (void)adViewDidReadyForCustomEvent:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate bannerCustomEvent:self didLoadAd:adView];
}

@end
