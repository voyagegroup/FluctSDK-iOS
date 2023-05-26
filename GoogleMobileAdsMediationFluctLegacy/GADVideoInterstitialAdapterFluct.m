//
//  GADVideoInterstitialAdapterFluct.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "GADVideoInterstitialAdapterFluct.h"
#import "GADMFluctError.h"

@import FluctSDK;

@interface GADVideoInterstitialAdapterFluct () <FSSVideoInterstitialDelegate, FSSVideoInterstitialRTBDelegate>
@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;
@property (nonatomic, nullable) FSSVideoInterstitial *videoInterstitial;
@end

@implementation GADVideoInterstitialAdapterFluct

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

    self.videoInterstitial = [[FSSVideoInterstitial alloc] initWithGroupId:self.groupID
                                                                    unitId:self.unitID
                                                                   setting:[FSSVideoInterstitialSetting defaultSetting]];
    self.videoInterstitial.delegate = self;
    self.videoInterstitial.rtbDelegate = self;
    [self.videoInterstitial loadAd];
}

- (void)presentFromRootViewController:(UIViewController *)rootViewController {
    if ([self.videoInterstitial hasAdAvailable]) {
        [self.videoInterstitial presentAdFromViewController:rootViewController];
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

- (void)videoInterstitialDidClick:(FSSVideoInterstitial *)interstitial {
    [self.delegate customEventInterstitialWasClicked:self];
}

@end
