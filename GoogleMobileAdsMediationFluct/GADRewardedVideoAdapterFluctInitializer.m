//
//  GADRewardedVideoAdapterFluctInitializer.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "GADRewardedVideoAdapterFluctInitializer.h"
#import "GADMAdapterFluctExtras.h"
#import "GADMFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface GADRewardedVideoAdapterFluctInitializer ()
@property (nonatomic, nullable, copy) GADMediationRewardedLoadCompletionHandler completionHandler;
@property (nonatomic, nullable) FSSInAppBidding *bidding;
@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *unitID;
@end

@implementation GADRewardedVideoAdapterFluctInitializer

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

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return [GADMAdapterFluctExtras class];
}

+ (GADVersionNumber)version {
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

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    NSString *params = adConfiguration.credentials.settings[GADCustomEventParametersServer];
    NSArray<NSString *> *ids = [params componentsSeparatedByString:@","];
    if (ids.count == 2) {
        self.groupID = ids.firstObject;
        self.unitID = ids.lastObject;
    }

    if (!self.groupID || !self.unitID) {
        NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                             code:GADMFluctErrorInvalidCustomParameters
                                         userInfo:@{}];
        completionHandler(nil, error);
        return;
    }

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeGoogleMobileAds;
    options.mediationPlatformSDKVersion = [NSString stringWithFormat:@"%s", GoogleMobileAdsVersionString];
    [FluctSDK configureWithOptions:options];

    BOOL debugMode = NO;
    GADMAdapterFluctExtras *extras = adConfiguration.extras;
    if (extras) {
        debugMode = extras.setting.isDebugMode;
    }

    self.completionHandler = completionHandler;
    self.bidding = [[FSSInAppBidding alloc] initWithGroupId:self.groupID
                                                     unitId:self.unitID
                                                   adFormat:FSSInAppBiddingAdFormatRewardedVideo
                                                  debugMode:debugMode];
    [self.bidding requestWithCompletion:^(FSSInAppBiddingResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            self.completionHandler(nil, error);
            self.completionHandler = nil;
            return;
        }

        [FSSInAppBiddingResponseCache.sharedInstance setResponse:response.value
                                                      forGroupId:self.groupID
                                                          unitId:self.unitID];

        NSError *err = [NSError errorWithDomain:GADMFluctErrorDomain
                                           code:GADMFluctErrorNoResponse
                                       userInfo:nil];
        self.completionHandler(nil, err);
        self.completionHandler = nil;
    }];
}

@end
