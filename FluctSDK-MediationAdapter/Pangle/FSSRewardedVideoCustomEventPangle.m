//
//  FSSRewardedVideoCustomEventPangle.m
//  FluctSDKApp
//
//  Copyright © 2021 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventPangle.h"
#import <BUAdSDK/BUAdSDK.h>

@interface FSSRewardedVideoCustomEventPangle () <BURewardedVideoAdDelegate>
@property (nonnull) BURewardedVideoAd *rewardedVideo;
@end

static NSString *const FSSPangleSupportVersion = @"10.0";

@implementation FSSRewardedVideoCustomEventPangle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting {

    if (![FSSRewardedVideoCustomEventPangle isOSAtLeastVersion:FSSPangleSupportVersion]) {
        return nil;
    }

    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:targeting];

    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [BUAdSDKManager setAppID:dictionary[@"app_id"]];
            [BUAdSDKManager setLoglevel:debugMode ? BUAdSDKLogLevelDebug : BUAdSDKLogLevelError];
        });
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        _rewardedVideo = [[BURewardedVideoAd alloc] initWithSlotID:dictionary[@"ad_placement_id"] rewardedVideoModel:model];
        _rewardedVideo.delegate = self;
    }

    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    [self.rewardedVideo loadAdData];
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    [self.rewardedVideo showAdFromRootViewController:viewController];
}

- (NSString *)sdkVersion {
    return BUAdSDKManager.SDKVersion;
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

#pragma mark - BURewardedVideoAdDelegate

- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    // noop
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                        code:FSSVideoErrorLoadFailed
                                                                                    userInfo:nil]
                                                     adnetworkError:error];
    });
}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)rewardedVideoAdWillVisible:(BURewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
    });
}

- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)rewardedVideoAdWillClose:(BURewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
    });
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:weakSelf];
    });
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    if (!error) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                        code:FSSVideoErrorPlayFailed
                                                                                    userInfo:nil]
                                                     adnetworkError:error];
    });
}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:self];
    });
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                        code:FSSVideoErrorPlayFailed
                                                                                    userInfo:nil]
                                                     adnetworkError:error];
    });
}

@end
