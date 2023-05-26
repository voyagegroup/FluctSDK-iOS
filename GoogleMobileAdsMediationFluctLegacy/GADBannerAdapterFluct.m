//
//  GADBannerAdapterFluct.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "GADBannerAdapterFluct.h"
#import "GADMFluctError.h"
@import FluctSDK;

@interface GADBannerAdapterFluct () <FSSAdViewDelegate>
@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;
@property (nonatomic) FSSAdView *adView;
@end

@implementation GADBannerAdapterFluct

@synthesize delegate;

- (void)requestBannerAd:(GADAdSize)adSize parameter:(NSString *)serverParameter label:(NSString *)serverLabel request:(GADCustomEventRequest *)request {
    NSError *error = nil;
    if (![self setupAdapterWithParameter:serverParameter error:&error]) {
        [self.delegate customEventBanner:self didFailAd:error];
        return;
    }

    FSSConfigurationOptions *options = FSSConfigurationOptions.defaultOptions;
    options.mediationPlatformType = FSSMediationPlatformTypeGoogleMobileAds;
    options.mediationPlatformSDKVersion = [NSString stringWithFormat:@"%s", GoogleMobileAdsVersionString];
    [FluctSDK configureWithOptions:options];

    self.adView = [[FSSAdView alloc] initWithGroupId:self.groupID unitId:self.unitID size:adSize.size];
    self.adView.delegate = self;

    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加する
    self.adView.hidden = YES;
    UIViewController *viewController = [self.delegate viewControllerForPresentingModalView];
    [viewController.view addSubview:self.adView];

    [self.adView loadAd];
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
    [self.delegate customEventBanner:self didReceiveAd:adView];
}

- (void)adView:(FSSAdView *)adView didFailToStoreAdWithError:(NSError *)error {
    // iOS12でloadされない問題の対応のため、viewController.viewのhierarchyに追加されているので
    // removeFromSuperviewする
    [adView removeFromSuperview];
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)willLeaveApplicationForAdView:(FSSAdView *)adView {
    [self.delegate customEventBannerWasClicked:self];
}

@end
