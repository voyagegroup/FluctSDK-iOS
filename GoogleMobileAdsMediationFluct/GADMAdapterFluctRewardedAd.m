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
#import <stdatomic.h>

@import FluctSDK;

@interface GADMAdapterFluctRewardedAd () <GADAdapterFluctVideoDelegateProxyItem>
@property (nonatomic, nullable, copy) GADMediationRewardedLoadCompletionHandler loadCompletionHandler;
@property (nonatomic, nullable, weak) id<GADMediationRewardedAdEventDelegate> adEventDelegate;
@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *unitID;
@end

@implementation GADMAdapterFluctRewardedAd

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {

    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationRewardedLoadCompletionHandler
        originalCompletionHandler = [completionHandler copy];

    self.loadCompletionHandler = ^id<GADMediationRewardedAdEventDelegate>(
        _Nullable id<GADMediationRewardedAd> ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }

        id<GADMediationRewardedAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
        }

        originalCompletionHandler = nil;

        return delegate;
    };

    NSError *error = nil;
    if (![self setupAdapterWithParameter:[adConfiguration.credentials.settings objectForKey:GADCustomEventParametersServer] error:&error]) {
        self.adEventDelegate = self.loadCompletionHandler(nil, error);
        return;
    }

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeGoogleMobileAds;
    options.mediationPlatformSDKVersion = [NSString stringWithFormat:@"%s", GoogleMobileAdsVersionString];
    [FluctSDK configureWithOptions:options];

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

    self.groupID = ids[0];
    self.unitID = ids[1];
    return YES;
}

#pragma mark - GADAdapterFluctVideoDelegateProxyItem
- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    self.adEventDelegate = self.loadCompletionHandler(self, nil);
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    NSError *err = [NSError errorWithDomain:GADMFluctErrorDomain
                                       code:error.code
                                   userInfo:error.userInfo];
    self.adEventDelegate = self.loadCompletionHandler(nil, err);
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
    [self.adEventDelegate didRewardUser];
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate willDismissFullScreenView];
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate didDismissFullScreenView];
}

@end
