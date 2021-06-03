//
//  GADRewardedVideoAdapterFluctOptimizer.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "GADRewardedVideoAdapterFluctOptimizer.h"
#import "GADAdapterFluctVideoDelegateProxy.h"
#import "GADMAdapterFluctExtras.h"
#import "GADMFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface GADRewardedVideoAdapterFluctOptimizer () <GADAdapterFluctVideoDelegateProxyItem, FSSRewardedVideoCustomEventOptimizerDelegate>
@property (nonatomic, nullable, copy) GADMediationRewardedLoadCompletionHandler completionHandler;
@property (nonatomic, nullable, weak) id<GADMediationRewardedAdEventDelegate> adEventDelegate;

@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *unitID;
@property (nonatomic, nullable, copy) NSString *pricePoint;
@property (nonatomic, nullable) FSSRewardedVideoCustomEventOptimizer *optimizer;
@end

@implementation GADRewardedVideoAdapterFluctOptimizer

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

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    NSArray<NSString *> *params = [adConfiguration.credentials.settings[GADCustomEventParametersServer] componentsSeparatedByString:@","];
    if (params.count == 3) {
        self.groupID = params[0];
        self.unitID = params[1];
        self.pricePoint = params[2];
    }

    if (!self.groupID || !self.unitID || !self.pricePoint) {
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

    self.completionHandler = completionHandler;
    self.optimizer = [[FSSRewardedVideoCustomEventOptimizer alloc] initWithGroupId:self.groupID
                                                                            unitId:self.unitID
                                                                        pricePoint:self.pricePoint];
    self.optimizer.delegate = self;

    FSSRewardedVideoSetting *setting = [FSSRewardedVideoSetting defaultSetting];
    GADMAdapterFluctExtras *extras = adConfiguration.extras;
    if (extras.setting) {
        setting = extras.setting;
    }

    [[GADAdapterFluctVideoDelegateProxy sharedInstance] registerDelegate:self
                                                                 groupId:self.groupID
                                                                  unitId:self.unitID];

    [self.optimizer requestWithSetting:setting
                              delegate:GADAdapterFluctVideoDelegateProxy.sharedInstance
                           rtbDelegate:GADAdapterFluctVideoDelegateProxy.sharedInstance];
}

- (void)presentFromViewController:(UIViewController *)viewController {
    if ([self.optimizer hasAdAvailable]) {
        [self.optimizer presentAdFromViewController:viewController];
    }
}

#pragma mark - FSSRewardedVideoCustomEventOptimizer

- (void)customEventNotFoundResponse:(FSSRewardedVideoCustomEventOptimizer *)customEvent {
    NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorNoResponse
                                     userInfo:nil];
    self.completionHandler(nil, error);
    self.completionHandler = nil;
}

#pragma mark - GADAdapterFluctVideoDelegateProxyItem

- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    if (self.completionHandler) {
        self.adEventDelegate = self.completionHandler(self, nil);
        self.completionHandler = nil;
    }
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    if (self.completionHandler) {
        NSError *err = [NSError errorWithDomain:GADMFluctErrorDomain
                                           code:error.code
                                       userInfo:error.userInfo];
        self.completionHandler(nil, err);
        self.completionHandler = nil;
    }
}

- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate willPresentFullScreenView];
}

- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate didStartVideo];
}

- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    NSError *err = [NSError errorWithDomain:GADMFluctErrorDomain
                                       code:error.code
                                   userInfo:error.userInfo];
    [self.adEventDelegate didFailToPresentWithError:err];
}

- (void)rewardedVideoShouldRewardForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate didEndVideo];
    GADAdReward *rewardItem = [[GADAdReward alloc] initWithRewardType:@""
                                                         rewardAmount:[NSDecimalNumber one]];
    [self.adEventDelegate didRewardUserWithReward:rewardItem];
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate willDismissFullScreenView];
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate didDismissFullScreenView];
}

- (void)rewardedVideoDidClickForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate reportClick];
}

@end
