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

@interface FluctBannerCustomEvent () <FSSAdViewDelegate>
@property (nonatomic, strong) FSSAdView *adView;
@end

@implementation FluctBannerCustomEvent

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

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

    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加する
    self.adView.hidden = YES;
    UIViewController *viewController = [self.delegate viewControllerForPresentingModalView];
    [viewController.view addSubview:self.adView];

    [self.adView loadAd];
}

#pragma mark - FSSAdViewDelegate

- (void)adViewDidStoreAd:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);
    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加されているので
    // removeFromSuperviewする必要あり
    [adView removeFromSuperview];
    adView.hidden = NO;

    [self.delegate bannerCustomEvent:self didLoadAd:adView];
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);
}

- (void)adView:(FSSAdView *)adView didFailToStoreAdWithError:(NSError *)error {
    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加されているので
    // removeFromSuperviewする
    [adView removeFromSuperview];
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
    [self.adView removeFromSuperview];
    self.adView = nil;
}

- (void)willLeaveApplicationForAdView:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)]);
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

@end
