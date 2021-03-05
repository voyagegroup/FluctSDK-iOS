//
//  FluctRewardedVideoCustomEvent.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FluctRewardedVideoCustomEvent.h"
#import "FluctCustomEventInfo.h"
#import "FluctInstanceMediationSettings.h"
#import "FluctRewardedVideoDelegateRouter.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctRewardedVideoCustomEvent () <FSSRewardedVideoDelegate, FSSRewardedVideoRTBDelegate>
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@end

@implementation FluctRewardedVideoCustomEvent

#pragma mark - MPFullscreenAdAdapter

- (BOOL)isRewardExpected {
    return YES;
}

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
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

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeMoPub;
    options.mediationPlatformSDKVersion = MP_SDK_VERSION;
    [FluctSDK configureWithOptions:options];

    [FluctRewardedVideoDelegateRouter.sharedInstance addDelegate:self
                                                         groupID:self.customEventInfo.groupID
                                                          unitID:self.customEventInfo.unitID];
    [FluctRewardedVideoDelegateRouter.sharedInstance addRTBDelegate:self
                                                            groupID:self.customEventInfo.groupID
                                                             unitID:self.customEventInfo.unitID];

    FSSRewardedVideo.sharedInstance.delegate = FluctRewardedVideoDelegateRouter.sharedInstance;
    FSSRewardedVideo.sharedInstance.rtbDelegate = FluctRewardedVideoDelegateRouter.sharedInstance;

    FSSAdRequestTargeting *targeting;
    FluctInstanceMediationSettings *mediationSettings = [self.delegate fullscreenAdAdapter:self instanceMediationSettingsForClass:[FluctInstanceMediationSettings class]];
    if (mediationSettings) {
        FSSRewardedVideo.sharedInstance.setting = mediationSettings.setting;
        targeting = mediationSettings.targeting;
    }

    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);
    [FSSRewardedVideo.sharedInstance loadRewardedVideoWithGroupId:self.customEventInfo.groupID
                                                           unitId:self.customEventInfo.unitID
                                                        targeting:targeting];
}

- (BOOL)hasAdAvailable {
    return [FSSRewardedVideo.sharedInstance hasAdAvailableForGroupId:self.customEventInfo.groupID
                                                              unitId:self.customEventInfo.unitID];
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    MPLogEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)]);
    MPLogEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)]);
    [FSSRewardedVideo.sharedInstance presentRewardedVideoAdForGroupId:self.customEventInfo.groupID
                                                               unitId:self.customEventInfo.unitID
                                                   fromViewController:viewController];
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
    MPReward *reward = [MPReward unspecifiedReward];
    MPLogEvent([MPLogEvent adShouldRewardUserWithReward:reward]);
    [self.delegate fullscreenAdAdapter:self willRewardUser:reward];
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdWillDisappear:self];

    // `fullscreenAdAdapterAdWillDismiss:` was introduced in MoPub SDK 5.15.0.
    if ([self.delegate respondsToSelector:@selector(fullscreenAdAdapterAdWillDismiss:)]) {
        [self.delegate fullscreenAdAdapterAdWillDismiss:self];
    }
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)]);
    MPLogEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];

    // Signal that the fullscreen ad is closing and the state should be reset.
    // `fullscreenAdAdapterAdDidDismiss:` was introduced in MoPub SDK 5.15.0.
    if ([self.delegate respondsToSelector:@selector(fullscreenAdAdapterAdDidDismiss:)]) {
        [self.delegate fullscreenAdAdapterAdDidDismiss:self];
    }
}

#pragma mark - FSSRewardedVideoRTBDelegate

- (void)rewardedVideoDidClickForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)]);
    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
    [self.delegate fullscreenAdAdapterDidTrackClick:self];
}

@end
