//
//  FSSRewardedVideoCustomEventPangle.m
//  FluctSDKApp
//
//  Copyright © 2021 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventPangle.h"
#import "FSSPangleLoadManager.h"
#import <PAGAdSDK/PAGAdSDK.h>

@interface FSSRewardedVideoCustomEventPangle () <FSSPangleLoadManagerDelegate, PAGRewardedAdDelegate>

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *slotId;
@property (nonatomic) FSSPangleLoadManager *pangleLoadManager;
@property (nonatomic) PAGRewardedAd *rewardedVideo;

@end

static NSString *const FSSPangleSupportVersion = @"12.0";

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

    return [self initWithDictionary:dictionary
                           delegate:delegate
                           testMode:testMode
                          debugMode:debugMode
                          skippable:skippable
                          targeting:nil
                  pangleLoadManager:[FSSPangleLoadManager sharedInstance]];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                 pangleLoadManager:(FSSPangleLoadManager *)pangleLoadManager {
    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:nil];

    self.appId = dictionary[@"app_id"];
    self.slotId = dictionary[@"ad_placement_id"];
    self.pangleLoadManager = pangleLoadManager;

    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    [self.pangleLoadManager loadWithAppId:self.appId
                                debugMode:self.debugMode
                                   slotId:self.slotId
                                 delegate:self];
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
    });
    [self.rewardedVideo presentFromRootViewController:viewController];
}

- (NSString *)sdkVersion {
    return PAGSdk.SDKVersion;
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

#pragma mark - FSSPangleLoadManagerDelegate

- (void)pangleFailedToInitializeWithFluctError:(NSError *)fluctError
                                adnetworkError:(NSError *)adnetworkError {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:fluctError
                                                     adnetworkError:adnetworkError];
    });
}

- (void)pangleRewardedAdDidLoad:(PAGRewardedAd *)rewardedAd {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
    self.rewardedVideo = rewardedAd;
    self.rewardedVideo.delegate = self;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)pangleRewardedAdFailedToLoad:(NSError *)error {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:FSSVideoErrorLoadFailed
                                              userInfo:nil];
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:fluctError
                                                     adnetworkError:error];
    });
}

#pragma mark - PAGRewardedAdDelegate

- (void)adDidShow:(PAGRewardedAd *)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)adDidClick:(PAGRewardedAd *)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:weakSelf];
    });
}

- (void)adDidDismiss:(PAGRewardedAd *)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

- (void)rewardedAd:(PAGRewardedAd *)rewardedAd userDidEarnReward:(PAGRewardModel *)rewardModel {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
    });
}

- (void)rewardedAd:(PAGRewardedAd *)rewardedAd userEarnRewardFailWithError:(NSError *)error {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:FSSVideoErrorPlayFailed
                                              userInfo:nil];
        [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                         fluctError:fluctError
                                                     adnetworkError:error];
    });
}

@end
