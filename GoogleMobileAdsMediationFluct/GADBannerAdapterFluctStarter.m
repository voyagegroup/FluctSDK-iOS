//
//  GADBannerAdapterFluctStarter.m
//  FluctSDK
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "GADBannerAdapterFluctStarter.h"
#import "GADMFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface GADBannerAdapterFluctStarter () <FSSBannerCustomEventStarterDelegate>
@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *unitID;
@property (nonatomic, nullable, copy) NSString *pricePoint;
@property (nonatomic, nullable) FSSBannerCustomEventStarter *starter;
@end

@implementation GADBannerAdapterFluctStarter

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

    self.starter = [[FSSBannerCustomEventStarter alloc] initWithGroupId:self.groupID
                                                                 unitId:self.unitID
                                                             pricePoint:self.pricePoint];
    self.starter.delegate = self;
    UIViewController *viewController = [self.delegate viewControllerForPresentingModalView];
    [self.starter requestWithAdSize:adSize.size rootViewController:viewController];
}

#pragma mark - FSSBannerCustomEventStarterDelegate

- (void)customEventNotFoundResponse:(FSSBannerCustomEventStarter *)customEvent {
    NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorNoResponse
                                     userInfo:nil];
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)customEvent:(FSSBannerCustomEventStarter *)customEvent didStoreAdView:(FSSAdView *)adView {
    [self.delegate customEventBanner:self didReceiveAd:adView];
}

- (void)customEvent:(FSSBannerCustomEventStarter *)customEvent didFailToStoreAdView:(FSSAdView *)adView withError:(NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)customEvent:(FSSBannerCustomEventStarter *)customEvent willLeaveApplicationForAdView:(FSSAdView *)adView {
    [self.delegate customEventBannerWasClicked:self];
}

#pragma mark - Setup

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

@end
