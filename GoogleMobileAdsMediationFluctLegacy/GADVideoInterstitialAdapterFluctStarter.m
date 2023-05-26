//
//  GADVideoInterstitialAdapterFluctStarter.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "GADVideoInterstitialAdapterFluctStarter.h"
#import "GADMFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface GADVideoInterstitialAdapterFluctStarter () <FSSVideoInterstitialDelegate, FSSVideoInterstitialRTBDelegate, FSSVideoInterstitialCustomEventStarterDelegate>
@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;
@property (nonatomic, nullable) NSString *pricePoint;
@property (nonatomic, nullable) FSSVideoInterstitialCustomEventStarter *starter;
@end

@implementation GADVideoInterstitialAdapterFluctStarter

@synthesize delegate;

- (void)requestInterstitialAdWithParameter:(NSString *)serverParameter
                                     label:(NSString *)serverLabel
                                   request:(GADCustomEventRequest *)request {

    NSError *error = nil;
    if (![self setupAdapterWithParameter:serverParameter error:&error]) {
        [self.delegate customEventInterstitial:self didFailAd:error];
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

- (void)presentFromRootViewController:(nonnull UIViewController *)rootViewController {
    if ([self.starter hasAdAvailable]) {
        [self.starter presentAdFromViewController:rootViewController];
    }
}

#pragma mark - FSSVideoInterstitialCustomEventStarterDelegate

- (void)customEventNotFoundResponse:(FSSVideoInterstitialCustomEventStarter *)customEvent {
    NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorNoResponse
                                     userInfo:nil];
    [self.delegate customEventInterstitial:self didFailAd:error];
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
    [self.delegate customEventInterstitialDidReceiveAd:self];
}

- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToLoadWithError:(NSError *)error {
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void)videoInterstitialWillAppear:(FSSVideoInterstitial *)interstitial {
    [self.delegate customEventInterstitialWillPresent:self];
}

- (void)videoInterstitialDidAppear:(FSSVideoInterstitial *)interstitial {
}

- (void)videoInterstitialWillDisappear:(FSSVideoInterstitial *)interstitial {
    [self.delegate customEventInterstitialWillDismiss:self];
}

- (void)videoInterstitialDidDisappear:(FSSVideoInterstitial *)interstitial {
    [self.delegate customEventInterstitialDidDismiss:self];
}

- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToPlayWithError:(NSError *)error {
    [self.delegate customEventInterstitial:self didFailAd:error];
}

#pragma mark - FSSVideoInterstitialRTBDelegate

- (void)videoInterstitialDidClick:(FSSVideoInterstitial *)interstitial {
    [self.delegate customEventInterstitialWasClicked:self];
}

@end
