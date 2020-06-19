//
//  FluctRewardedVideoCustomEventOptimizer.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FluctRewardedVideoCustomEventOptimizer.h"
#import "FluctCustomEventInfo.h"
#import "FluctInstanceMediationSettings.h"
#import "FluctRewardedVideoDelegateRouter.h"
#import "MoPubAdapterFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctRewardedVideoCustomEventOptimizer () <FSSRewardedVideoDelegate, FSSRewardedVideoRTBDelegate, FSSRewardedVideoCustomEventOptimizerDelegate>
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@property (nonatomic, nullable) FSSRewardedVideoCustomEventOptimizer *optimizer;
@end

@implementation FluctRewardedVideoCustomEventOptimizer

/**
 * clickとimpressionを手動でtrackingしたいので
 */
- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

- (BOOL)isRewardExpected {
    return YES;
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError *error;
    self.customEventInfo = [FluctCustomEventInfo customEventInfoFromMoPubInfo:info
                                                                        error:&error];
    if (error) {
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }

    if (!self.customEventInfo.pricePoint) {
        NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                             code:MoPubAdapterFluctErrorInvalidCustomParameters
                                         userInfo:nil];
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeMoPub;
    options.mediationPlatformSDKVersion = MP_SDK_VERSION;
    [FluctSDK configureWithOptions:options];

    self.optimizer = [[FSSRewardedVideoCustomEventOptimizer alloc] initWithGroupId:self.customEventInfo.groupID
                                                                            unitId:self.customEventInfo.unitID
                                                                        pricePoint:self.customEventInfo.pricePoint];
    self.optimizer.delegate = self;

    FSSRewardedVideoSetting *setting = [FSSRewardedVideoSetting defaultSetting];
    FluctInstanceMediationSettings *mediationSettings = [self.delegate fullscreenAdAdapter:self instanceMediationSettingsForClass:[FluctInstanceMediationSettings class]];
    if (mediationSettings) {
        setting = mediationSettings.setting;
    }

    [FluctRewardedVideoDelegateRouter.sharedInstance addDelegate:self
                                                         groupID:self.customEventInfo.groupID
                                                          unitID:self.customEventInfo.unitID];
    [FluctRewardedVideoDelegateRouter.sharedInstance addRTBDelegate:self
                                                            groupID:self.customEventInfo.groupID
                                                             unitID:self.customEventInfo.unitID];

    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);
    [self.optimizer requestWithSetting:setting
                              delegate:FluctRewardedVideoDelegateRouter.sharedInstance
                           rtbDelegate:FluctRewardedVideoDelegateRouter.sharedInstance];
}

- (BOOL)hasAdAvailable {
    return [self.optimizer hasAdAvailable];
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    MPLogEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)]);
    MPLogEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)]);
    [self.optimizer presentAdFromViewController:viewController];
}

#pragma mark - FSSRewardedVideoCustomEventOptimizerDelegate

- (void)customEventNotFoundResponse:(FSSRewardedVideoCustomEventOptimizer *)customEvent {
    NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                         code:MoPubAdapterFluctErrorNoResponse
                                     userInfo:nil];
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

#pragma mark - FSSRewardedVideoDelegate

- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdWillAppear:self];
}

- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdDidAppear:self];
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterDidTrackImpression:self];
}

- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    MPLogEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:error];
}

- (void)rewardedVideoShouldRewardForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyAmount:@0];
    MPLogEvent([MPLogEvent adShouldRewardUserWithReward:reward]);
    [self.delegate fullscreenAdAdapter:self willRewardUser:reward];
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdWillDisappear:self];
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)]);
    MPLogEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
}

#pragma mark - FSSRewardedVideoRTBDelegate

- (void)rewardedVideoDidClickForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
    [self.delegate fullscreenAdAdapterDidTrackClick:self];
}

@end
