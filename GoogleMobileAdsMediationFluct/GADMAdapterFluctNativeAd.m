//
//  GADMAdapterFluctNativeAd.m
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import "GADMAdapterFluctNativeAd.h"
#import "GADMFluctError.h"
#import "GADMediationAdapterFluctUtil.h"
@import FluctSDK;
#import <stdatomic.h>

@interface GADMAdapterFluctNativeAd () <FSSMediationNativeAdLoaderDelegate>
@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;
@property (nonatomic) FSSMediationNativeAdLoader *adLoader;

@property (nonatomic) GADMediationNativeLoadCompletionHandler loadCompletionHandler;
@property (nonatomic, weak) id<GADMediationNativeAdEventDelegate> adEventDelegate;
@property (nonatomic, nullable) FSSMediationNativeAd *nativeAd;
@end

@implementation GADMAdapterFluctNativeAd

- (void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                     completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler {

    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationNativeLoadCompletionHandler
        originalCompletionHandler = [completionHandler copy];

    self.loadCompletionHandler = ^id<GADMediationNativeAdEventDelegate>(
        _Nullable id<GADMediationNativeAd> ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }

        id<GADMediationNativeAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
        }

        originalCompletionHandler = nil;

        return delegate;
    };

    NSError *error = nil;
    if (![self setupAdapterWithParameter:[adConfiguration.credentials.settings objectForKey:GADCustomEventParametersServer] error:&error]) {
        self.adEventDelegate = self.loadCompletionHandler(nil, error);
        return;
    }

    FSSConfigurationOptions *options = FSSConfigurationOptions.defaultOptions;
    options.mediationPlatformType = FSSMediationPlatformTypeGoogleMobileAds;
    options.mediationPlatformSDKVersion = [NSString stringWithFormat:@"%s", GoogleMobileAdsVersionString];
    [FluctSDK configureWithOptions:options];

    self.adLoader = [[FSSMediationNativeAdLoader alloc] initWithGroupId:self.groupID unitId:self.unitID];
    self.adLoader.delegate = self;
    [self.adLoader loadAd];
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

#pragma mark - FSSMediationNativeAdLoaderDelegate

- (void)mediationNativeAdLoader:(FSSMediationNativeAdLoader *)adLoader didStoreMediationNativeAd:(FSSMediationNativeAd *)nativeAd {
    self.nativeAd = nativeAd;
    self.adEventDelegate = self.loadCompletionHandler(self, nil);
}

- (void)mediationNativeAdLoader:(FSSMediationNativeAdLoader *)adLoader didFailToStoreAdWithError:(NSError *)error {
    self.adEventDelegate = self.loadCompletionHandler(nil, error);
}

#pragma mark - GADMediationNativeAd

- (nullable NSString *)headline {
    return self.nativeAd.headline;
}

- (nullable NSString *)advertiser {
    return self.nativeAd.advertiser;
}

- (nullable NSString *)callToAction {
    return self.nativeAd.callToAction;
}

- (nullable NSArray<GADNativeAdImage *> *)images {
    UIImage *mainImage = self.nativeAd.mediaContent.mainImage;
    if (!mainImage) {
        return nil;
    }
    return @[ [[GADNativeAdImage alloc] initWithImage:mainImage] ];
}

- (nullable NSString *)body {
    return nil;
}

- (nullable GADNativeAdImage *)icon {
    return nil;
}

- (nullable NSDecimalNumber *)starRating {
    return nil;
}

- (nullable NSString *)store {
    return nil;
}

- (nullable NSString *)price {
    return nil;
}

- (nullable NSDictionary<NSString *, id> *)extraAssets {
    return nil;
}

- (nullable UIView *)adChoicesView {
    return self.nativeAd.adChoicesView;
}

- (void)didRenderInView:(UIView *)view
       clickableAssetViews:(NSDictionary<GADNativeAssetIdentifier, UIView *> *)clickableAssetViews
    nonclickableAssetViews:(NSDictionary<GADNativeAssetIdentifier, UIView *> *)nonclickableAssetViews
            viewController:(UIViewController *)viewController {
}

- (void)didRecordImpression {
    [self.nativeAd trackImpression];
}

- (void)didRecordClickOnAssetWithName:(GADNativeAssetIdentifier)assetName
                                 view:(UIView *)view
                       viewController:(UIViewController *)viewController {
    [self.nativeAd handleClickWithViewController:viewController];
}

- (void)didUntrackView:(nullable UIView *)view {
}

@end
