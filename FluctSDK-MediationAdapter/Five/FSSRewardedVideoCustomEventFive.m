//
//  FSSRewardedVideoCustomEventFive.m
//  FluctSDKApp
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventFive.h"
#import <FiveAd/FiveAd.h>

typedef NS_ENUM(NSInteger, FiveErrorExtend) {
    FiveErrorExtendNotReady = -1
};

@interface FSSRewardedVideoCustomEventFive () <FADLoadDelegate, FADVideoRewardEventListener>
@property (nonnull) FADVideoReward *rewardedVideo;
@end

static NSString *const FSSFiveSupportVersion = @"12.0";

@implementation FSSRewardedVideoCustomEventFive

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                           setting:(id<FSSFullscreenVideoSetting>)setting {

    if (![FSSRewardedVideoCustomEventFive isOSAtLeastVersion:FSSFiveSupportVersion]) {
        return nil;
    }

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FADConfig *config = [[FADConfig alloc] initWithAppId:dictionary[@"app_id"]];
        config.isTest = testMode;
        [FADSettings registerConfig:config];
    });

    return [self initWithDictionary:dictionary
                           delegate:delegate
                           testMode:testMode
                          debugMode:debugMode
                          skippable:skippable
                          targeting:targeting
                            setting:setting
                      rewardedVideo:[[FADVideoReward alloc] initWithSlotId:dictionary[@"slot_id"]]];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                           setting:(id<FSSFullscreenVideoSetting>)setting
                     rewardedVideo:(FADVideoReward *)rewardedVideo {

    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:targeting
                             setting:setting];

    if (self) {
        self.rewardedVideo = rewardedVideo;
        [self.rewardedVideo setLoadDelegate:self];
        [self.rewardedVideo setEventListener:self];
    }

    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    [self.rewardedVideo loadAdAsync];
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    [self.rewardedVideo showWithViewController:viewController];
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
}

- (NSString *)sdkVersion {
    return FADSettings.semanticVersion;
}

#pragma mark - FADLoadDelegate
- (void)fiveAdDidLoad:(id<FADAdInterface>)ad {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:self];
    });
}

- (void)fiveAd:(id<FADAdInterface>)ad didFailedToReceiveAdWithError:(FADErrorCode)errorCode {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                              code:FSSVideoErrorLoadFailed
                                          userInfo:nil];
    NSError *fiveError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                             code:errorCode
                                         userInfo:nil];
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:self fluctError:fluctError adnetworkError:fiveError];
    });
}

#pragma mark - FADVideoRewardEventListener
- (void)fiveVideoRewardAdDidPlay:(nonnull FADVideoReward *)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:self];
    });
}

- (void)fiveVideoRewardAdDidReward:(nonnull FADVideoReward *)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:self];
    });
}

- (void)fiveVideoRewardAdDidClick:(nonnull FADVideoReward *)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:self];
    });
}

- (void)fiveVideoRewardAdFullScreenDidClose:(nonnull FADVideoReward *)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:self];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:self];
    });
}

- (void)fiveVideoRewardAd:(nonnull FADVideoReward *)ad didFailedToShowAdWithError:(FADErrorCode)errorCode {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                              code:FSSVideoErrorPlayFailed
                                          userInfo:nil];
    NSError *fiveError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                             code:errorCode
                                         userInfo:nil];
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:self fluctError:fluctError adnetworkError:fiveError];
    });
}

@end
