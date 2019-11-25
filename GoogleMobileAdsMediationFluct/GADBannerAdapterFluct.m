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
@property (nonatomic) FSSAdSize adSize;
@property (nonatomic) FSSAdView *adView;
@end

@implementation GADBannerAdapterFluct

@synthesize delegate;

- (void)requestBannerAd:(GADAdSize)adSize parameter:(NSString *)serverParameter label:(NSString *)serverLabel request:(GADCustomEventRequest *)request {
    NSError *error = nil;
    if (![self setupAdapterWithParameter:serverParameter adSize:adSize error:&error]) {
        [self.delegate customEventBanner:self didFailAd:error];
        return;
    }

    FSSConfigurationOptions *options = FSSConfigurationOptions.defaultOptions;
    options.mediationPlatformType = FSSMediationPlatformTypeGoogleMobileAds;
    options.mediationPlatformSDKVersion = [NSString stringWithFormat:@"%s", GoogleMobileAdsVersionString];
    [FluctSDK configureWithOptions:options];

    self.adView = [[FSSAdView alloc] initWithGroupId:self.groupID unitId:self.unitID adSize:self.adSize];
    self.adView.delegate = self;
    [self.adView loadAd];
}

#pragma mark - setup
- (BOOL)setupAdapterWithParameter:(NSString *)serverParameter adSize:(GADAdSize)adSize error:(NSError **)error {
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

    if (CGSizeEqualToSize(adSize.size, FSSAdSize320x50.size)) {
        self.adSize = FSSAdSize320x50;
    } else if (CGSizeEqualToSize(adSize.size, FSSAdSize300x250.size)) {
        self.adSize = FSSAdSize300x250;
    } else {
        *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                     code:GADMFluctErrorInvalidSize
                                 userInfo:@{}];
        return NO;
    }
    return YES;
}

#pragma mark - FSSAdViewDelegate
- (void)adViewDidStoreAd:(FSSAdView *)adView {
    [self.delegate customEventBanner:self didReceiveAd:adView];
}

- (void)adView:(FSSAdView *)adView didFailToStoreAdWithError:(NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)willLeaveApplicationForAdView:(FSSAdView *)adView {
    [self.delegate customEventBannerWasClicked:self];
    [self.delegate customEventBannerWillLeaveApplication:self];
}

@end
