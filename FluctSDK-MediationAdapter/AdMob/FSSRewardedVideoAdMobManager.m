//
//  FSSRewardedVideoAdMobManager.m
//  FluctSDK
//
//  Copyright © 2019年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoAdMobManager.h"

@interface FSSRewardedVideoAdMobManager ()
//AdMob handle only one ad at time.
//ref: https://github.com/voyagegroup/FluctSDK-iOS-Dev/issues/731
@property id<FSSRewardedVideoAdMobManagerDelegate> delegate;
@property NSString *currentAdUnitId;
@property NSString *applicationID;
@end

@implementation FSSRewardedVideoAdMobManager
+ (instancetype)sharedInstance {
    static FSSRewardedVideoAdMobManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (void)loadWithApplicationID:(NSString *)applicationID
                     adUnitID:(NSString *)adUnitID
                     delegate:(id<FSSRewardedVideoAdMobManagerDelegate>)delegate {
    if (!self.applicationID) {
        __weak typeof(self) weakSelf = self;
        [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus *_Nonnull status) {
            weakSelf.applicationID = applicationID;
            GADRewardBasedVideoAd.sharedInstance.delegate = weakSelf;
            [weakSelf loadWithApplicationID:applicationID adUnitID:adUnitID delegate:delegate];
        }];
        return;
    }

    if (!self.currentAdUnitId) {
        //Now no AdUnit is proccessed
        self.currentAdUnitId = adUnitID;
        self.delegate = delegate;
        GADRequest *request = [GADRequest request];
        [[GADRewardBasedVideoAd sharedInstance] loadRequest:request withAdUnitID:adUnitID];
        return;
    }

    if (![self.currentAdUnitId isEqualToString:adUnitID]) {
        //other adUnitID is processed. error.
        [delegate rewardBasedVideoOtherAdUnitProcessed];
        return;
    }

    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        //same adUnitID and already loaded.
        [delegate rewardBasedVideoAdDidReceiveAd];
        return;
    }

    //same adUnitID and still laoding
    //do nothind.
}

- (void)presentFromViewController:(UIViewController *)viewController {
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:viewController];
    }
}

#pragma mark - GADRewardBasedVideoAdDelegate
- (void)rewardBasedVideoAd:(nonnull GADRewardBasedVideoAd *)rewardBasedVideoAd
    didRewardUserWithReward:(nonnull GADAdReward *)reward {
    [self.delegate didRewardUser];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    [self.delegate didFailToLoadWithError:error];
    self.delegate = nil;
    self.currentAdUnitId = nil;
}
- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [self.delegate rewardBasedVideoAdDidReceiveAd];
}
- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [self.delegate rewardBasedVideoAdDidOpen];
}
- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [self.delegate rewardBasedVideoAdDidClose];
    self.delegate = nil;
    self.currentAdUnitId = nil;
}
@end
