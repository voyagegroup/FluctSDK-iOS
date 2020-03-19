//
//  FluctRewardedVideoCustomEventInitializer.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FluctRewardedVideoCustomEventInitializer.h"
#import "FluctCustomEventInfo.h"
#import "FluctInstanceMediationSettings.h"
#import "MoPubAdapterFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctRewardedVideoCustomEventInitializer ()
@property (nonatomic, nullable) FSSInAppBidding *bidding;
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@end

@implementation FluctRewardedVideoCustomEventInitializer

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
        MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);

        NSError *err = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                           code:MoPubAdapterFluctErrorNoResponse
                                       userInfo:nil];
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:err];
    }];
}

@end
