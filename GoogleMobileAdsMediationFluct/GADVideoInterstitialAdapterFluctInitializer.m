//
//  GADVideoInterstitialAdapterFluctInitializer.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "GADVideoInterstitialAdapterFluctInitializer.h"
#import "GADMFluctError.h"

#import <FluctSDK/FluctSDK.h>

@interface GADVideoInterstitialAdapterFluctInitializer ()
@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;
@property (nonatomic, nullable) FSSInAppBidding *bidding;
@end

@implementation GADVideoInterstitialAdapterFluctInitializer

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

    self.bidding = [[FSSInAppBidding alloc] initWithGroupId:self.groupID unitId:self.unitID adFormat:FSSInAppBiddingAdFormatVideoInterstitial];
    [self.bidding requestWithCompletion:^(FSSInAppBiddingResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            [self.delegate customEventInterstitial:self didFailAd:error];
            return;
        }

        [FSSInAppBiddingResponseCache.sharedInstance setResponse:response.value
                                                      forGroupId:self.groupID
                                                          unitId:self.unitID];

        NSError *err = [NSError errorWithDomain:GADMFluctErrorDomain
                                           code:GADMFluctErrorNoResponse
                                       userInfo:nil];
        [self.delegate customEventInterstitial:self didFailAd:err];
    }];
}

- (void)presentFromRootViewController:(nonnull UIViewController *)rootViewController {
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

@end
