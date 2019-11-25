//
//  FSSRewardedVideoCustomEventMintegral.m
//  FluctSDK
//
//  Copyright © 2019年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventMintegral.h"
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKReward/MTGRewardAdManager.h>

typedef NS_ENUM(NSInteger, MintegralErrorExtend) {
    MintegralErrorExtendPlayFailed = -1,
    MintegralErrorExtendUnexpectedUnitId = -2
};

@interface FSSRewardedVideoCustomEventMintegral () <MTGRewardAdLoadDelegate, MTGRewardAdShowDelegate>
@property (nonnull) NSString *unitId;
@end

@implementation FSSRewardedVideoCustomEventMintegral

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         targeting:(FSSAdRequestTargeting *)targeting {

    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           targeting:targeting];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [MTGSDK.sharedInstance setAppID:dictionary[@"app_id"]
                                 ApiKey:dictionary[@"app_key"]];
    });

    if (self) {
        _unitId = dictionary[@"ad_unit_id"];
    }

    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    if ([MTGRewardAdManager.sharedInstance isVideoReadyToPlay:self.unitId]) {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [self.delegate rewardedVideoDidLoadForCustomEvent:self];
        return;
    }

    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    [MTGRewardAdManager.sharedInstance loadVideo:self.unitId delegate:self];
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    if ([MTGRewardAdManager.sharedInstance isVideoReadyToPlay:self.unitId]) {
        [MTGRewardAdManager.sharedInstance showVideo:self.unitId
                                        withRewardId:@"1"
                                              userId:@""
                                            delegate:self
                                      viewController:viewController];
    } else {
        self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        NSError *error = [NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                             code:FSSRewardedVideoAdErrorLoadFailed
                                         userInfo:nil];
        [self.delegate rewardedVideoDidFailToLoadForCustomEvent:self
                                                     fluctError:error
                                                 adnetworkError:error];
    }
}

- (NSString *)sdkVersion {
    return MTGSDKVersion;
}

#pragma mark - MTGRewardAdLoadDelegate
- (void)onVideoAdLoadSuccess:(nullable NSString *)unitId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        if (![unitId isEqualToString:weakSelf.unitId]) {
            //unexpected
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:self
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorLoadFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:MintegralErrorExtendUnexpectedUnitId
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"unexpected unit id when onVideoAdLoadSuccess."}]];
            return;
        }

        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)onVideoAdLoadFailed:(nullable NSString *)unitId error:(nonnull NSError *)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        NSError *fluctError = [NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                  code:FSSRewardedVideoAdErrorLoadFailed
                                              userInfo:nil];
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:self
                                                         fluctError:fluctError
                                                     adnetworkError:error];
    });
}

#pragma mark - MTGRewardAdShowDelegate
- (void)onVideoAdShowSuccess:(nullable NSString *)unitId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        if (![unitId isEqualToString:weakSelf.unitId]) {
            //unexpected
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorPlayFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:MintegralErrorExtendUnexpectedUnitId
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"unexpected unit id when onVideoAdShowSuccess."}]];
            return;
        }

        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)onVideoAdShowFailed:(nullable NSString *)unitId withError:(nonnull NSError *)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        NSError *fluctError = [NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                  code:FSSRewardedVideoAdErrorPlayFailed
                                              userInfo:nil];
        [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                         fluctError:fluctError
                                                     adnetworkError:error];
    });
}

- (void)onVideoPlayCompleted:(nullable NSString *)unitId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        if (![unitId isEqualToString:weakSelf.unitId]) {
            //unexpected
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorPlayFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:MintegralErrorExtendUnexpectedUnitId
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"unexpected unit id when onVideoPlayCompleted."}]];
            return;
        }

        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
    });
}

- (void)onVideoAdClicked:(nullable NSString *)unitId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        if (![unitId isEqualToString:weakSelf.unitId]) {
            //unexpected
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorPlayFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:MintegralErrorExtendUnexpectedUnitId
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"unexpected unit id when onVideoAdClicked."}]];
            return;
        }

        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:weakSelf];
    });
}

- (void)onVideoAdDismissed:(nullable NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(nullable MTGRewardAdInfo *)rewardInfo {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        if (![unitId isEqualToString:weakSelf.unitId]) {
            //unexpected
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorPlayFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:MintegralErrorExtendUnexpectedUnitId
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"unexpected unit id when onVideoAdDismissed."}]];
            return;
        }

        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

@end
