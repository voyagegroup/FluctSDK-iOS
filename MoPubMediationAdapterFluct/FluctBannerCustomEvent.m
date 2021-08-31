//
//  FluctBannerCustomEvent.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FluctBannerCustomEvent.h"
#import "FluctBannerSize.h"
#import "FluctCustomEventInfo.h"
#import "MoPubAdapterFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctBannerCustomEvent () <FSSAdViewDelegate>
@property (nonatomic, strong) FSSAdView *bannerView;
@end

@implementation FluctBannerCustomEvent

- (void)requestAdWithSize:(CGSize)size adapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError *error;
    FluctCustomEventInfo *customEventInfo = [FluctCustomEventInfo customEventInfoFromMoPubInfo:info
                                                                                         error:&error];
    if (error) {
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }

    FSSAdSize adSize = [FluctBannerSize getFluctAdSize:size];
    if (CGSizeEqualToSize(adSize.size, CGSizeZero)) {
        error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                    code:MoPubAdapterFluctErrorInvalidAdSize
                                userInfo:@{NSLocalizedDescriptionKey : @"invalid ad unit format"}];
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeMoPub;
    options.mediationPlatformSDKVersion = MP_SDK_VERSION;
    [FluctSDK configureWithOptions:options];

    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);

    self.bannerView = [[FSSAdView alloc] initWithGroupId:customEventInfo.groupID unitId:customEventInfo.unitID adSize:adSize];
    self.bannerView.delegate = self;

    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加する
    self.bannerView.hidden = YES;
    UIViewController *viewController = [self.delegate inlineAdAdapterViewControllerForPresentingModalView:self];
    [viewController.view addSubview:self.bannerView];

    [self.bannerView loadAd];
}

#pragma mark - FSSAdViewDelegate

- (void)adViewDidStoreAd:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);
    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加されているので
    // removeFromSuperviewする必要あり
    [adView removeFromSuperview];
    adView.hidden = NO;

    [self.delegate inlineAdAdapter:self didLoadAdWithAdView:adView];
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);
}

- (void)adView:(FSSAdView *)adView didFailToStoreAdWithError:(NSError *)error {
    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加されているので
    // removeFromSuperviewする
    [adView removeFromSuperview];
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}

- (void)willLeaveApplicationForAdView:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)]);
    [self.delegate inlineAdAdapterWillLeaveApplication:self];
}

@end
