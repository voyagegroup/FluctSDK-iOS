//
//  FluctBannerCustomEventOptimizer.m
//  FluctSDK
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "FluctBannerCustomEventOptimizer.h"
#import "FluctCustomEventInfo.h"
#import "MoPubAdapterFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctBannerCustomEventOptimizer () <FSSBannerCustomEventOptimizerDelegate>
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@property (nonatomic, nullable) FSSBannerCustomEventOptimizer *optimizer;
@end

@implementation FluctBannerCustomEventOptimizer

#pragma mark - MPInlineAdapter

- (void)requestAdWithSize:(CGSize)size adapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError *error;
    self.customEventInfo = [FluctCustomEventInfo customEventInfoFromMoPubInfo:info
                                                                        error:&error];
    if (error) {
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }

    if (!self.customEventInfo.pricePoint) {
        NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                             code:MoPubAdapterFluctErrorInvalidCustomParameters
                                         userInfo:nil];
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeMoPub;
    options.mediationPlatformSDKVersion = MP_SDK_VERSION;
    [FluctSDK configureWithOptions:options];

    self.optimizer = [[FSSBannerCustomEventOptimizer alloc] initWithGroupId:self.customEventInfo.groupID
                                                                     unitId:self.customEventInfo.unitID
                                                                 pricePoint:self.customEventInfo.pricePoint];
    self.optimizer.delegate = self;

    UIViewController *viewController = [self.delegate inlineAdAdapterViewControllerForPresentingModalView:self];
    [self.optimizer requestWithRootViewController:viewController size:size];
}

#pragma mark - FSSBannerCustomEventOptimizerDelegate

- (void)customEventNotFoundResponse:(FSSBannerCustomEventOptimizer *)customEvent {
    NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                         code:MoPubAdapterFluctErrorNoResponse
                                     userInfo:nil];
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent didStoreAdView:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate inlineAdAdapter:self didLoadAdWithAdView:adView];
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);
}

- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent didFailToStoreAdView:(FSSAdView *)adView withError:(NSError *)error {
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent willLeaveApplicationForAdView:(FSSAdView *)adView {
    MPLogEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)]);
    [self.delegate inlineAdAdapterWillLeaveApplication:self];
}

@end
