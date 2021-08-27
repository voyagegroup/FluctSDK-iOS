//
//  GADBannerAdapterFluctOptimizer.m
//  FluctSDK
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "GADBannerAdapterFluctOptimizer.h"
#import "GADMFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface GADBannerAdapterFluctOptimizer () <FSSBannerCustomEventOptimizerDelegate>
@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;
@property (nonatomic, nullable) NSString *pricePoint;
@property (nonatomic, nullable) FSSBannerCustomEventOptimizer *optimizer;
@end

@implementation GADBannerAdapterFluctOptimizer

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

    self.optimizer = [[FSSBannerCustomEventOptimizer alloc] initWithGroupId:self.groupID
                                                                     unitId:self.unitID
                                                                 pricePoint:self.pricePoint];
    self.optimizer.delegate = self;

    UIViewController *viewController = [self.delegate viewControllerForPresentingModalView];
    [self.optimizer requestWithRootViewController:viewController size:adSize.size];
}

#pragma mark - FSSBannerCustomEventOptimizer

- (void)customEventNotFoundResponse:(FSSBannerCustomEventOptimizer *)customEvent {
    NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorNoResponse
                                     userInfo:nil];
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent didStoreAdView:(FSSAdView *)adView {
    [self.delegate customEventBanner:self didReceiveAd:adView];
}

- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent didFailToStoreAdView:(FSSAdView *)adView withError:(NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent willLeaveApplicationForAdView:(FSSAdView *)adView {
    [self.delegate customEventBannerWasClicked:self];
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

@end
