//
//  FluctVideoInterstitialCustomEvent.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FluctVideoInterstitialCustomEvent.h"
#import "FluctCustomEventInfo.h"
#import "FluctRewardedVideoDelegateRouter.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctVideoInterstitialCustomEvent () <FSSRewardedVideoDelegate>
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@end

@implementation FluctVideoInterstitialCustomEvent

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError *error;
    self.customEventInfo = [FluctCustomEventInfo customEventInfoFromMoPubInfo:info
                                                                        error:&error];
    if (error) {
        MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
        return;
    }

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeMoPub;
    options.mediationPlatformSDKVersion = MP_SDK_VERSION;
    [FluctSDK configureWithOptions:options];

    [FluctRewardedVideoDelegateRouter.sharedInstance addDelegate:self
                                                         groupID:self.customEventInfo.groupID
                                                          unitID:self.customEventInfo.unitID];

    FSSRewardedVideo.sharedInstance.delegate = FluctRewardedVideoDelegateRouter.sharedInstance;

    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);

    [FSSRewardedVideo.sharedInstance loadRewardedVideoWithGroupId:self.customEventInfo.groupID
                                                           unitId:self.customEventInfo.unitID];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    MPLogEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)]);
    MPLogEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)]);
    [FSSRewardedVideo.sharedInstance presentRewardedVideoAdForGroupId:self.customEventInfo.groupID
                                                               unitId:self.customEventInfo.unitID
                                                   fromViewController:rootViewController];
}

#pragma mark - FSSRewardedVideoDelegate

- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEvent:self didLoadAd:FSSRewardedVideo.sharedInstance];
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    MPLogEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error]);
}

- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEventWillAppear:self];
}

- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEventDidAppear:self];
    MPLogEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)]);
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEventWillDisappear:self];
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    MPLogEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)]);
    [self.delegate interstitialCustomEventDidDisappear:self];
    MPLogEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)]);
}

@end
