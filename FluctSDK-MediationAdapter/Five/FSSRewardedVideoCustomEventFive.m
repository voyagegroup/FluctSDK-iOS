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

@interface FSSRewardedVideoCustomEventFive () <FADLoadDelegate, FADAdViewEventListener>
@property (nonnull) FADVideoReward *rewardedVideo;
@end

@implementation FSSRewardedVideoCustomEventFive

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting {

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
                      rewardedVideo:[[FADVideoReward alloc] initWithSlotId:dictionary[@"slot_id"]]];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                     rewardedVideo:(FADVideoReward *)rewardedVideo {

    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:targeting];

    if (self) {
        self.rewardedVideo = rewardedVideo;
        [self.rewardedVideo setLoadDelegate:self];
        [self.rewardedVideo setAdViewEventListener:self];
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
    if (self.rewardedVideo.state != kFADStateLoaded) {
        self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:FSSVideoErrorNotReady
                                              userInfo:nil];
        NSError *fiveError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                 code:FiveErrorExtendNotReady
                                             userInfo:nil];
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                     fluctError:fluctError
                                                 adnetworkError:fiveError];
        return;
    }
    [self.rewardedVideo show];
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
}

- (NSString *)sdkVersion {
    return FADSettings.version;
}

#pragma mark - FADLoadDelegate
- (void)fiveAdDidLoad:(id<FADAdInterface>)ad {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
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
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:self fluctError:fluctError adnetworkError:fiveError];
    });
}

#pragma mark - FADAdViewEventListener
- (void)fiveAdDidStart:(id<FADAdInterface>)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:self];
    });
}

- (void)fiveAdDidClose:(id<FADAdInterface>)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
        //- (void)fiveAdDidViewThrough:(id<FADAdInterface>)adは呼ばれない時もあるので使わない。
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:self];
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:self];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:self];
    });
}

- (void)fiveAdDidClick:(id<FADAdInterface>)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:self];
    });
}

- (void)fiveAd:(id<FADAdInterface>)ad didFailedToShowAdWithError:(FADErrorCode)errorCode {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                              code:FSSVideoErrorPlayFailed
                                          userInfo:nil];
    NSError *fiveError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                             code:errorCode
                                         userInfo:nil];
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:self fluctError:fluctError adnetworkError:fiveError];
    });
}

@end
