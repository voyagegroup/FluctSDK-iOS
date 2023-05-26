//
//  GADVideoInterstitialAdapterFluctStarter.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "GADVideoInterstitialAdapterFluctStarter.h"
#import "GADMFluctError.h"
#import "GADMediationAdapterFluctUtil.h"
#import <FluctSDK/FluctSDK.h>
#import <stdatomic.h>

@interface GADVideoInterstitialAdapterFluctStarter () <FSSVideoInterstitialDelegate, FSSVideoInterstitialRTBDelegate, FSSVideoInterstitialCustomEventStarterDelegate>
@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;
@property (nonatomic, nullable) NSString *pricePoint;
@property (nonatomic, nullable) FSSVideoInterstitialCustomEventStarter *starter;
@property (nonatomic) GADMediationInterstitialLoadCompletionHandler loadCompletionHandler;
@property (nonatomic, weak) id<GADMediationInterstitialAdEventDelegate> adEventDelegate;
@end

@implementation GADVideoInterstitialAdapterFluctStarter

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

    self.starter = [[FSSVideoInterstitialCustomEventStarter alloc] initWithGroupId:self.groupID unitId:self.unitID pricePoint:self.pricePoint];
    self.starter.delegate = self;

    FSSVideoInterstitialSetting *setting = [FSSVideoInterstitialSetting defaultSetting];
    [self.starter requestWithSetting:setting delegate:self rtbDelegate:self];
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
    if ([self.starter hasAdAvailable]) {
        [self.starter presentAdFromViewController:viewController];
    } else {
        NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                             code:GADMFluctErrorHasNotAdAvailable
                                         userInfo:nil];
        [self.adEventDelegate didFailToPresentWithError:error];
    }
}

#pragma mark - FSSVideoInterstitialCustomEventStarterDelegate

- (void)customEventNotFoundResponse:(FSSVideoInterstitialCustomEventStarter *)customEvent {
    NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorNoResponse
                                     userInfo:nil];
    // adEventDelegateを確実に解放するため代入しています
    self.adEventDelegate = self.loadCompletionHandler(nil, error);
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

#pragma mark - FSSVideoInterstitialRTBDelegate

- (void)videoInterstitialDidClick:(FSSVideoInterstitial *)interstitial {
    [self.adEventDelegate reportClick];
}

@end
