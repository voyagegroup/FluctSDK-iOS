//
//  GADMAdapterFluctNativeAd.m
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import "GADMAdapterFluctNativeAd.h"
#import "GADMAdapterFluctExtras.h"
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
@property (nonatomic) GADAdChoicesPosition adChoicesPosition;
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

    // publisher が GADNativeAdViewAdOptions で指定した ad choices の表示位置を取得する
    self.adChoicesPosition = GADAdChoicesPositionTopRightCorner;
    for (GADAdLoaderOptions *option in adConfiguration.options) {
        if ([option isKindOfClass:[GADNativeAdViewAdOptions class]]) {
            self.adChoicesPosition = ((GADNativeAdViewAdOptions *)option).preferredAdChoicesPosition;
            break;
        }
    }

    FSSConfigurationOptions *options = FSSConfigurationOptions.defaultOptions;
    options.mediationPlatformType = FSSMediationPlatformTypeGoogleMobileAds;
    options.mediationPlatformSDKVersion = [NSString stringWithFormat:@"%s", GoogleMobileAdsVersionString];
    [FluctSDK configureWithOptions:options];

    GADMAdapterFluctExtras *extras = adConfiguration.extras;
    if (extras.targeting) {
        self.adLoader = [[FSSMediationNativeAdLoader alloc] initWithGroupId:self.groupID
                                                                     unitId:self.unitID
                                                                  targeting:extras.targeting];
    } else {
        self.adLoader = [[FSSMediationNativeAdLoader alloc] initWithGroupId:self.groupID
                                                                     unitId:self.unitID];
    }
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
    self.nativeAd.informationIconView.position =
        [GADMAdapterFluctNativeAd informationIconPositionFromAdChoicesPosition:self.adChoicesPosition];
    self.adEventDelegate = self.loadCompletionHandler(self, nil);
}

+ (FSSNativeAdInformationIconPosition)informationIconPositionFromAdChoicesPosition:(GADAdChoicesPosition)position {
    switch (position) {
    case GADAdChoicesPositionTopLeftCorner:
        return FSSNativeAdInformationIconPositionTopLeft;
    case GADAdChoicesPositionBottomRightCorner:
        return FSSNativeAdInformationIconPositionBottomRight;
    case GADAdChoicesPositionBottomLeftCorner:
        return FSSNativeAdInformationIconPositionBottomLeft;
    case GADAdChoicesPositionTopRightCorner:
    default:
        return FSSNativeAdInformationIconPositionTopRight;
    }
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
    return self.nativeAd.body;
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
    return self.nativeAd.informationIconView;
}

// fluct側でimpressionを計測し reportImpression でGMAに通知する。
// これによりアプリへ nativeAdDidRecordImpression が配送される
- (BOOL)handlesUserImpressions {
    return YES;
}

// fluct側でクリックを検知し reportClick でGMAに通知する。
// これによりアプリへ nativeAdDidRecordClick が配送される。
// NO(GMA側でクリック検知)にすると didRecordClickOnAssetWithName: は呼ばれるが、
// アプリへ nativeAdDidRecordClick が配送されない
- (BOOL)handlesUserClicks {
    return YES;
}

- (void)didRenderInView:(UIView *)view
       clickableAssetViews:(NSDictionary<GADNativeAssetIdentifier, UIView *> *)clickableAssetViews
    nonclickableAssetViews:(NSDictionary<GADNativeAssetIdentifier, UIView *> *)nonclickableAssetViews
            viewController:(UIViewController *)viewController {
    __weak __typeof(self) weakSelf = self;
    [self.nativeAd startImpressionTrackingWithView:view
                                        completion:^{
                                            [weakSelf.adEventDelegate reportImpression];
                                        }];
    // fluct側はタップのたびにこのcompletionを呼ぶ(クリックは重複排除しない)。
    // ただし連続タップしてもアプリへの nativeAdDidRecordClick は1回しか配送されない。
    // (差分) GMA自身のネイティブ広告はアセットを連続タップすると nativeAdDidRecordClick が複数回発火する。
    [self.nativeAd startClickTrackingWithView:view
                               clickableViews:clickableAssetViews.allValues
                               viewController:viewController
                                   completion:^{
                                       [weakSelf.adEventDelegate reportClick];
                                   }];
}

- (void)didRecordImpression {
    // handlesUserImpressions = YES のため呼ばれない想定
}

- (void)didRecordClickOnAssetWithName:(GADNativeAssetIdentifier)assetName
                                 view:(UIView *)view
                       viewController:(UIViewController *)viewController {
    // handlesUserClicks = YES のため呼ばれない想定
}

- (void)didUntrackView:(nullable UIView *)view {
    [self.nativeAd stopImpressionTracking];
    [self.nativeAd stopClickTracking];
}

@end
