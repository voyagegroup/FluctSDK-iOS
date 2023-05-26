//
//  GADVideoInterstitialAdapterFluct.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "GADVideoInterstitialAdapterFluct.h"
#import "GADMFluctError.h"
#import "GADMediationAdapterFluctUtil.h"
#import <stdatomic.h>

@import FluctSDK;

@interface GADVideoInterstitialAdapterFluct () <FSSVideoInterstitialDelegate, FSSVideoInterstitialRTBDelegate>
@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;
@property (nonatomic, nullable) FSSVideoInterstitial *videoInterstitial;
@property (nonatomic) GADMediationInterstitialLoadCompletionHandler loadCompletionHandler;
@property (nonatomic, weak) id<GADMediationInterstitialAdEventDelegate> adEventDelegate;
@end

@implementation GADVideoInterstitialAdapterFluct

- (void)loadInterstitialForAdConfiguration:
            (nonnull GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:(nonnull GADMediationInterstitialLoadCompletionHandler)
                                               completionHandler {

    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationInterstitialLoadCompletionHandler
        originalCompletionHandler = [completionHandler copy];

    self.loadCompletionHandler = ^id<GADMediationInterstitialAdEventDelegate>(
        _Nullable id<GADMediationInterstitialAd> ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }

        id<GADMediationInterstitialAdEventDelegate> delegate = nil;
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

    self.videoInterstitial = [[FSSVideoInterstitial alloc] initWithGroupId:self.groupID
                                                                    unitId:self.unitID
                                                                   setting:[FSSVideoInterstitialSetting defaultSetting]];
    self.videoInterstitial.delegate = self;
    self.videoInterstitial.rtbDelegate = self;
    [self.videoInterstitial loadAd];
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

- (void)presentFromViewController:(nonnull UIViewController *)viewController {
    if ([self.videoInterstitial hasAdAvailable]) {
        [self.videoInterstitial presentAdFromViewController:viewController];
    }
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

#pragma mark - FSSVideoInterstitialDelegate
- (void)videoInterstitialDidLoad:(FSSVideoInterstitial *)interstitial {
    self.adEventDelegate = self.loadCompletionHandler(self, nil);
}

- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToLoadWithError:(NSError *)error {
    // adEventDelegateを確実に解放するため代入しています
    self.adEventDelegate = self.loadCompletionHandler(nil, error);
}

- (void)videoInterstitialWillAppear:(FSSVideoInterstitial *)interstitial {
    [self.adEventDelegate willPresentFullScreenView];
    [self.adEventDelegate reportImpression];
}

- (void)videoInterstitialDidAppear:(FSSVideoInterstitial *)interstitial {
    // do nothing
}

- (void)videoInterstitialWillDisappear:(FSSVideoInterstitial *)interstitial {
    [self.adEventDelegate willDismissFullScreenView];
}

- (void)videoInterstitialDidDisappear:(FSSVideoInterstitial *)interstitial {
    [self.adEventDelegate didDismissFullScreenView];
}

- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToPlayWithError:(NSError *)error {
    [self.adEventDelegate didFailToPresentWithError:error];
}

- (void)videoInterstitialDidClick:(FSSVideoInterstitial *)interstitial {
    [self.adEventDelegate reportClick];
}

@end
