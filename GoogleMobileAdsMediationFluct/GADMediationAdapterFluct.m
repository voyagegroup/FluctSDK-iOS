//
//  GADMediationAdapterFluct.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "GADMediationAdapterFluct.h"
#import "GADMAdapterFluctExtras.h"
#import "GADMAdapterFluctRewardedAd.h"
#import "GADMFluctError.h"
#import "GADMediationAdapterFluctUtil.h"

@import FluctSDK;

@interface GADMediationAdapterFluct ()
@property (nonatomic, nullable) GADMAdapterFluctRewardedAd *rewardedAd;
@end

@implementation GADMediationAdapterFluct

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
    return [GADMAdapterFluctExtras class];
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    self.rewardedAd = [GADMAdapterFluctRewardedAd new];
    [self.rewardedAd loadRewardedAdForAdConfiguration:adConfiguration
                                    completionHandler:completionHandler];
}

@end
