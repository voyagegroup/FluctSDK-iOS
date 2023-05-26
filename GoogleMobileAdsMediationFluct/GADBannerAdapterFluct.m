//
//  GADBannerAdapterFluct.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "GADBannerAdapterFluct.h"
#import "GADMFluctError.h"
#import "GADMediationAdapterFluctUtil.h"
@import FluctSDK;
#import <stdatomic.h>

@interface GADBannerAdapterFluct () <FSSAdViewDelegate>
@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;
@property (nonatomic) FSSAdView *adView;

@property (nonatomic) GADMediationBannerLoadCompletionHandler loadCompletionHandler;
@property (nonatomic, weak) id<GADMediationBannerAdEventDelegate> adEventDelegate;
@end

@implementation GADBannerAdapterFluct

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

    self.adView = [[FSSAdView alloc] initWithGroupId:self.groupID unitId:self.unitID size:adConfiguration.adSize.size];
    self.adView.delegate = self;

    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加する
    UIViewController *topViewController = adConfiguration.topViewController;
    if (!topViewController) {
        NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                             code:GADMFluctErrorViewControllerUnavailable
                                         userInfo:nil];
        // adEventDelegateを確実に解放するため代入しています
        self.adEventDelegate = self.loadCompletionHandler(nil, error);
        return;
    }

    self.adView.hidden = YES;
    [topViewController.view addSubview:self.adView];

    [self.adView loadAd];
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

#pragma mark - setup
- (BOOL)setupAdapterWithParameter:(NSString *)serverParameter error:(NSError **)error {
    NSArray<NSString *> *ids = [serverParameter componentsSeparatedByString:@","];
    if (ids.count != 2) {
        if (error) {
            *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorInvalidCustomParameters
                                     userInfo:@{}];
        }
        return NO;
    }

    self.groupID = ids.firstObject;
    self.unitID = ids.lastObject;
    return YES;
}

#pragma mark - FSSAdViewDelegate

- (void)adViewDidStoreAd:(FSSAdView *)adView {
    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加されているので
    // removeFromSuperviewする必要あり
    [adView removeFromSuperview];
    adView.hidden = NO;
    self.adEventDelegate = self.loadCompletionHandler(self, nil);
}

- (void)adView:(FSSAdView *)adView didFailToStoreAdWithError:(NSError *)error {
    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加されているので
    // removeFromSuperviewする
    [adView removeFromSuperview];
    // adEventDelegateを確実に解放するため代入しています
    self.adEventDelegate = self.loadCompletionHandler(nil, error);
}

- (void)willLeaveApplicationForAdView:(FSSAdView *)adView {
    [self.adEventDelegate reportClick];
}

#pragma mark - GADMediationBannerAd

- (UIView *)view {
    return self.adView;
}

@end
