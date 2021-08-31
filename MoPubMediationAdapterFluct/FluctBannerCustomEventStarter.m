//
//  FluctBannerCustomEventStarter.m
//  FluctSDK
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "FluctBannerCustomEventStarter.h"
#import "FluctBannerSize.h"
#import "FluctCustomEventInfo.h"
#import "MoPubAdapterFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctBannerCustomEventStarter () <FSSBannerCustomEventStarterDelegate>
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@property (nonatomic, nullable) FSSBannerCustomEventStarter *starter;
@end

@implementation FluctBannerCustomEventStarter

- (void)requestAdWithSize:(CGSize)size adapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError *error;
    self.customEventInfo = [FluctCustomEventInfo customEventInfoFromMoPubInfo:info
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

    if (!self.customEventInfo.pricePoint) {
        NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                             code:MoPubAdapterFluctErrorInvalidCustomParameters
                                         userInfo:nil];
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }

    self.starter = [[FSSBannerCustomEventStarter alloc] initWithGroupId:self.customEventInfo.groupID
                                                                 unitId:self.customEventInfo.unitID
                                                             pricePoint:self.customEventInfo.pricePoint];
    self.starter.delegate = self;

    UIViewController *viewController = [self.delegate inlineAdAdapterViewControllerForPresentingModalView:self];
    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);
    [self.starter requestWithAdSize:adSize.size rootViewController:viewController];
}

#pragma mark - FSSBannerCustomEventStarterDelegate

- (void)customEventNotFoundResponse:(FSSBannerCustomEventStarter *)customEvent {
    NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                         code:MoPubAdapterFluctErrorNoResponse
                                     userInfo:nil];
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)customEvent:(FSSBannerCustomEventStarter *)customEvent didStoreAdView:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate inlineAdAdapter:self didLoadAdWithAdView:adView];
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);
}

- (void)customEvent:(FSSBannerCustomEventStarter *)customEvent didFailToStoreAdView:(FSSAdView *)adView withError:(NSError *)error {
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)customEvent:(FSSBannerCustomEventStarter *)customEvent willLeaveApplicationForAdView:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)]);
    [self.delegate inlineAdAdapterWillLeaveApplication:self];
}

@end
