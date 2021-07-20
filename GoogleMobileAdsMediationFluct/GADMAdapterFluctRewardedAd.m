//
//  GADMAdapterFluctRewardedAd.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "GADMAdapterFluctRewardedAd.h"
#import "GADAdapterFluctVideoDelegateProxy.h"
#import "GADMAdapterFluctExtras.h"
#import "GADMFluctError.h"

@import FluctSDK;

@interface GADMAdapterFluctRewardedAd () <GADAdapterFluctVideoDelegateProxyItem>
@property (nonatomic, nullable, copy) GADMediationRewardedLoadCompletionHandler completionHandler;
@property (nonatomic, nullable, weak) id<GADMediationRewardedAdEventDelegate> adEventDelegate;
@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *unitID;
@end

@implementation GADMAdapterFluctRewardedAd

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
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

    self.completionHandler = completionHandler;

    [[GADAdapterFluctVideoDelegateProxy sharedInstance] registerDelegate:self groupId:self.groupID unitId:self.unitID];
    FSSRewardedVideo.sharedInstance.delegate = GADAdapterFluctVideoDelegateProxy.sharedInstance;

    GADMAdapterFluctExtras *extras = adConfiguration.extras;
    if (extras.setting) {
        FSSRewardedVideo.sharedInstance.setting = extras.setting;
    }
    if (extras.targeting) {
        [[FSSRewardedVideo sharedInstance] loadRewardedVideoWithGroupId:self.groupID
                                                                 unitId:self.unitID
                                                              targeting:extras.targeting];
        return;
    }

    [[FSSRewardedVideo sharedInstance] loadRewardedVideoWithGroupId:self.groupID
                                                             unitId:self.unitID];
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController {
    [[FSSRewardedVideo sharedInstance] presentRewardedVideoAdForGroupId:self.groupID
                                                                 unitId:self.unitID
                                                     fromViewController:viewController];
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

@end
