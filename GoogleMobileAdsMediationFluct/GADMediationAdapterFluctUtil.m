//
//  GADMediationAdapterFluctUtil.m
//  GoogleMobileAdsMediationFluct
//
//  Copyright © 2023 fluct, inc. All rights reserved.
//

#import "GADMediationAdapterFluctUtil.h"
#import "GADMFluctError.h"
#import <FluctSDK/FluctSDK.h>

@implementation GADMediationAdapterFluctUtil

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
    NSMutableSet *params = [[NSMutableSet alloc] init];
    for (GADMediationCredentials *credential in configuration.credentials) {
        NSString *param = [credential.settings valueForKey:GADCustomEventParametersServer];
        if (param) {
            [params addObject:param];
        }
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
@end
