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

@import FluctSDK;

@interface GADMediationAdapterFluct ()
@property (nonatomic, nullable) GADMAdapterFluctRewardedAd *rewardedAd;
@end

@implementation GADMediationAdapterFluct

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
    NSMutableSet *params = [[NSMutableSet alloc] init];
    for (GADMediationCredentials *credential in configuration.credentials) {
        NSString *param = [credential.settings valueForKey:GADCustomEventParametersServer];
        [params addObject:param];
    }

    if (params.count == 0) {
        // custom event parameters がセットされていない
        NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                             code:GADMFluctErrorInvalidCustomParameters
                                         userInfo:nil];
        completionHandler(error);
        return;
    }

    completionHandler(nil);
}

+ (GADVersionNumber)adSDKVersion {
    NSString *versionString = [FluctSDK version];
    NSArray<NSString *> *versionComponents = [versionString componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count == 3) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
}

+ (GADVersionNumber)adapterVersion {
    NSString *versionString = [FluctSDK version];
    NSArray<NSString *> *versionComponents = [versionString componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count == 3) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
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
