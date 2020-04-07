//
//  FluctVideoInterstitialCustomEventInitializer.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FluctVideoInterstitialCustomEventInitializer.h"
#import "FluctCustomEventInfo.h"
#import "MoPubAdapterFluctError.h"
#import <FluctSDK/FluctSDK.h>

@interface FluctVideoInterstitialCustomEventInitializer ()
@property (nonatomic, nullable) FSSInAppBidding *bidding;
@property (nonatomic, nullable) FluctCustomEventInfo *customEventInfo;
@end

@implementation FluctVideoInterstitialCustomEventInitializer

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

    self.bidding = [[FSSInAppBidding alloc] initWithGroupId:self.customEventInfo.groupID
                                                     unitId:self.customEventInfo.unitID
                                                   adFormat:FSSInAppBiddingAdFormatVideoInterstitial];
    MPLogEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil]);
    [self.bidding requestWithCompletion:^(FSSInAppBiddingResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            MPLogEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error]);
            [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
            return;
        }

        [FSSInAppBiddingResponseCache.sharedInstance setResponse:response.value
                                                      forGroupId:self.customEventInfo.groupID
                                                          unitId:self.customEventInfo.unitID];
        MPLogEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)]);

        NSError *err = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                           code:MoPubAdapterFluctErrorNoResponse
                                       userInfo:nil];
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:err];
    }];
}

@end
