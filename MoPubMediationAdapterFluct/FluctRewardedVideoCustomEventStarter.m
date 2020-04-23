//
//  FluctRewardedVideoCustomEventStarter.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FluctRewardedVideoCustomEventStarter.h"
#import "FluctCustomEventInfo.h"
#import "FluctInstanceMediationSettings.h"
#import "FluctRewardedVideoDelegateRouter.h"
#import "MoPubAdapterFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctRewardedVideoCustomEventStarter () <FSSRewardedVideoDelegate, FSSRewardedVideoRTBDelegate>
@property (nonatomic, nullable) FSSInAppBidding *bidding;
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@end

@implementation FluctRewardedVideoCustomEventStarter

/**
 * clickとimpressionを手動でtrackingする
 */
- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError *error;
    self.customEventInfo = [FluctCustomEventInfo customEventInfoFromMoPubInfo:info
                                                                        error:&error];
    if (error) {
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
        return;
    }

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeMoPub;
    options.mediationPlatformSDKVersion = MP_SDK_VERSION;
    [FluctSDK configureWithOptions:options];

    BOOL debugMode = NO;
    FluctInstanceMediationSettings *mediationSettings = [self.delegate instanceMediationSettingsForClass:[FluctInstanceMediationSettings class]];
    if (mediationSettings && mediationSettings.setting) {
        debugMode = mediationSettings.setting.isDebugMode;
    }

    self.bidding = [[FSSInAppBidding alloc] initWithGroupId:self.customEventInfo.groupID
                                                     unitId:self.customEventInfo.unitID
                                                   adFormat:FSSInAppBiddingAdFormatRewardedVideo
                                                  debugMode:debugMode];

    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);
    [self.bidding requestWithCompletion:^(FSSInAppBiddingResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
            [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
            return;
        }

        [FSSInAppBiddingResponseCache.sharedInstance setResponse:response.value
                                                      forGroupId:self.customEventInfo.groupID
                                                          unitId:self.customEventInfo.unitID];

        [self loadRewardedVideo];
    }];
}

- (BOOL)hasAdAvailable {
    return [FSSRewardedVideo.sharedInstance hasAdAvailableForGroupId:self.customEventInfo.groupID
                                                              unitId:self.customEventInfo.unitID];
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController {
    MPLogEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)]);
    MPLogEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)]);
    [FSSRewardedVideo.sharedInstance presentRewardedVideoAdForGroupId:self.customEventInfo.groupID
                                                               unitId:self.customEventInfo.unitID
                                                   fromViewController:viewController];
}

#pragma mark - Load FSSRewardedVideo

- (void)loadRewardedVideo {
    if (!self.customEventInfo.pricePoint) {
        NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                             code:MoPubAdapterFluctErrorInvalidCustomParameters
                                         userInfo:nil];
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
        return;
    }

    NSDictionary<NSString *, id> *adInfo = [FSSInAppBiddingResponseCache.sharedInstance responseForGroupId:self.customEventInfo.groupID
                                                                                                    unitId:self.customEventInfo.unitID
                                                                                                pricePoint:self.customEventInfo.pricePoint];
    if (!adInfo) {
        NSError *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                             code:MoPubAdapterFluctErrorNoResponse
                                         userInfo:nil];
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
        return;
    }

    [FluctRewardedVideoDelegateRouter.sharedInstance addDelegate:self
                                                         groupID:self.customEventInfo.groupID
                                                          unitID:self.customEventInfo.unitID];
    [FluctRewardedVideoDelegateRouter.sharedInstance addRTBDelegate:self
                                                            groupID:self.customEventInfo.groupID
                                                             unitID:self.customEventInfo.unitID];
    FSSRewardedVideo.sharedInstance.delegate = FluctRewardedVideoDelegateRouter.sharedInstance;
    FSSRewardedVideo.sharedInstance.rtbDelegate = FluctRewardedVideoDelegateRouter.sharedInstance;

    FluctInstanceMediationSettings *mediationSettings = [self.delegate instanceMediationSettingsForClass:[FluctInstanceMediationSettings class]];
    if (mediationSettings) {
        FSSRewardedVideo.sharedInstance.setting = mediationSettings.setting;
    }

    [FSSRewardedVideo.sharedInstance loadRewardedVideoWithGroupId:self.customEventInfo.groupID
                                                           unitId:self.customEventInfo.unitID
                                                             info:adInfo];
}

#pragma mark - FSSRewardedVideoDelegate

- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
}

- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
}

- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);

    // 表示できたらimp
    [self.delegate trackImpression];
}

- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    MPLogEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
}

- (void)rewardedVideoShouldRewardForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyAmount:@0];
    MPLogEvent([MPLogEvent adShouldRewardUserWithReward:reward]);
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:reward];
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)]);
    MPLogEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)]);
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

#pragma mark - FSSRewardedVideoRTBDelegate

- (void)rewardedVideoDidClickForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)]);
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    // click
    [self.delegate trackClick];
}

@end
