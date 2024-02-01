//
//  FSSRewardedVideoCustomEventNend.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventNend.h"
#import <NendAd/NendAd.h>

typedef NS_ENUM(NSInteger, NADRewardedVideoErrorExtend) {
    NADRewardedVideoErrorExtendNotReady = -2,
    NADRewardedVideoErrorExtendPlayFailed = -1
};

@interface FSSRewardedVideoCustomEventNend () <NADRewardedVideoDelegate>

@property (nonatomic) NADRewardedVideo *nendRewardedVideo;

@end

static NSString *const FSSNendSupportVersion = @"11.0";

@implementation FSSRewardedVideoCustomEventNend

+ (NADRewardedVideo *)initializeNendSDKWithSpotId:(NSString *)spotId apiKey:(NSString *)apiKey {
    return [[NADRewardedVideo alloc] initWithSpotID:spotId.integerValue apiKey:apiKey];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                           setting:(id<FSSFullscreenVideoSetting>)setting {

    if (![FSSRewardedVideoCustomEventNend isOSAtLeastVersion:FSSNendSupportVersion]) {
        return nil;
    }

    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:nil
                             setting:setting];

    _nendRewardedVideo = [FSSRewardedVideoCustomEventNend initializeNendSDKWithSpotId:dictionary[@"spot_id"] apiKey:dictionary[@"api_key"]];
    _nendRewardedVideo.delegate = self;

    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    if (!self.nendRewardedVideo.isReady) {
        [self.nendRewardedVideo loadAd];
        self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    } else {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [self.delegate rewardedVideoDidLoadForCustomEvent:self];
    }
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    if (self.nendRewardedVideo.isReady) {
        [self.nendRewardedVideo showAdFromViewController:viewController];
        [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    } else {
        NSError *error = [NSError errorWithDomain:FSSVideoErrorSDKDomain code:FSSVideoErrorNotReady userInfo:nil];
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                     fluctError:error
                                                 adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                    code:NADRewardedVideoErrorExtendNotReady
                                                                                userInfo:@{NSLocalizedDescriptionKey : @"not ready"}]];
    }
}

// nend SDK not support api for get sdk version
- (NSString *)sdkVersion {
    return @"";
}

#pragma mark NADRewardedVideoDelegate

- (void)nadRewardVideoAdDidReceiveAd:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)nadRewardVideoAd:(NADRewardedVideo *)nadRewardedVideoAd didFailToLoadWithError:(NSError *)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                        code:[self rewardedVideoErrorCodeWithError:error]
                                                                                    userInfo:nil]
                                                     adnetworkError:error];
    });
}

- (FSSVideoError)rewardedVideoErrorCodeWithError:(NSError *)error {
    switch (error.code) {
    case 204:
        return FSSVideoErrorNoAds;

    case 400:
        return FSSVideoErrorBadRequest;

    default:
        return FSSVideoErrorLoadFailed;
    }
}

- (void)nadRewardVideoAdDidFailedToPlay:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                        code:FSSVideoErrorPlayFailed
                                                                                    userInfo:nil]
                                                     adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                        code:NADRewardedVideoErrorExtendPlayFailed
                                                                                    userInfo:@{NSLocalizedDescriptionKey : @"play failed"}]];
    });
}

- (void)nadRewardVideoAdDidOpen:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)nadRewardVideoAdDidClose:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

- (void)nadRewardVideoAdDidClickAd:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:weakSelf];
    });
}

- (void)nadRewardVideoAd:(NADRewardedVideo *)nadRewardedVideoAd didReward:(NADReward *)reward {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
    });
}

@end
