//
//  GADBannerAdapterFluctOptimizer.m
//  FluctSDK
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "GADBannerAdapterFluctOptimizer.h"
#import "GADMFluctError.h"
#import "GADMediationAdapterFluctUtil.h"
#import <FluctSDK/FluctSDK.h>
#import <stdatomic.h>

@interface GADBannerAdapterFluctOptimizer () <FSSBannerCustomEventOptimizerDelegate>
@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;
@property (nonatomic, nullable) NSString *pricePoint;
@property (nonatomic, nullable) FSSBannerCustomEventOptimizer *optimizer;
@property (nonatomic) FSSAdView *adView;

@property (nonatomic) GADMediationBannerLoadCompletionHandler loadCompletionHandler;
@property (nonatomic, weak) id<GADMediationBannerAdEventDelegate> adEventDelegate;
@end

@implementation GADBannerAdapterFluctOptimizer

- (void)loadBannerForAdConfiguration:(nonnull GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:(nonnull GADMediationBannerLoadCompletionHandler)completionHandler {

    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationBannerLoadCompletionHandler
        originalCompletionHandler = [completionHandler copy];

    self.loadCompletionHandler = ^id<GADMediationBannerAdEventDelegate>(
        _Nullable id<GADMediationBannerAd> ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }

        id<GADMediationBannerAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
        }

        originalCompletionHandler = nil;

        return delegate;
    };

    NSError *error = nil;
    if (![self setupAdapterWithParameter:[adConfiguration.credentials.settings objectForKey:GADCustomEventParametersServer] error:&error]) {
        // adEventDelegateを確実に解放するため代入しています
        self.adEventDelegate = self.loadCompletionHandler(nil, error);
        return;
    }

    FSSConfigurationOptions *options = FSSConfigurationOptions.defaultOptions;
    options.mediationPlatformType = FSSMediationPlatformTypeGoogleMobileAds;
    options.mediationPlatformSDKVersion = [NSString stringWithFormat:@"%s", GoogleMobileAdsVersionString];
    [FluctSDK configureWithOptions:options];

    self.optimizer = [[FSSBannerCustomEventOptimizer alloc] initWithGroupId:self.groupID
                                                                     unitId:self.unitID
                                                                 pricePoint:self.pricePoint];
    self.optimizer.delegate = self;

    UIViewController *topViewController = adConfiguration.topViewController;
    if (!topViewController) {
        NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                             code:GADMFluctErrorViewControllerUnavailable
                                         userInfo:nil];
        // adEventDelegateを確実に解放するため代入しています
        self.adEventDelegate = self.loadCompletionHandler(nil, error);
        return;
    }

    [self.optimizer requestWithTopViewController:topViewController size:adConfiguration.adSize.size];
}

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
    [GADMediationAdapterFluctUtil setUpWithConfiguration:configuration
                                       completionHandler:completionHandler];
}

+ (GADVersionNumber)adSDKVersion {
    return [GADMediationAdapterFluctUtil adSDKVersion];
}

+ (GADVersionNumber)adapterVersion {
    return [GADMediationAdapterFluctUtil adapterVersion];
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return nil;
}

#pragma mark - FSSBannerCustomEventOptimizer

- (void)customEventNotFoundResponse:(FSSBannerCustomEventOptimizer *)customEvent {
    NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorNoResponse
                                     userInfo:nil];
    // adEventDelegateを確実に解放するため代入しています
    self.adEventDelegate = self.loadCompletionHandler(nil, error);
}

- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent didStoreAdView:(FSSAdView *)adView {
    self.adView = adView;
    self.adEventDelegate = self.loadCompletionHandler(self, nil);
}

- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent didFailToStoreAdView:(FSSAdView *)adView withError:(NSError *)error {
    // adEventDelegateを確実に解放するため代入しています
    self.adEventDelegate = self.loadCompletionHandler(nil, error);
}

- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent willLeaveApplicationForAdView:(FSSAdView *)adView {
    [self.adEventDelegate reportClick];
}

#pragma mark - setup

- (BOOL)setupAdapterWithParameter:(NSString *)serverParameter error:(NSError **)error {
    NSArray<NSString *> *ids = [serverParameter componentsSeparatedByString:@","];
    if (ids.count != 3) {
        if (error) {
            *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorInvalidCustomParameters
                                     userInfo:@{}];
        }
        return NO;
    }

    self.groupID = ids[0];
    self.unitID = ids[1];
    self.pricePoint = ids[2];
    return YES;
}

#pragma mark - GADMediationBannerAd

- (UIView *)view {
    return self.adView;
}

@end
