//
//  FSSRewardedVideoCustomEventAdMob.m
//  FluctSDK
//
//  Copyright © 2019年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventAdMob.h"

typedef NS_ENUM(NSInteger, FSSAdMobVideoErrorExtendend) {
    FSSAdMobVideoErrorExtendendTimeout = -1,
    FSSAdMobVideoErrorExtendendProcessingAnotherAd = -2,
};

@interface FSSRewardedVideoCustomEventAdMob ()
@property (nonatomic, copy, readonly) NSString *applicationID;
@property (nonatomic, copy, readonly) NSString *adUnitID;
@end

@implementation FSSRewardedVideoCustomEventAdMob
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         targeting:(FSSAdRequestTargeting *)targeting {
    self = [super initWithDictionary:dictionary delegate:delegate testMode:testMode debugMode:debugMode targeting:nil];
    if (self) {
        _applicationID = dictionary[@"application_id"];
        _adUnitID = dictionary[@"ad_unit_id"];
    }
    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    [[FSSRewardedVideoAdMobManager sharedInstance] loadWithApplicationID:self.applicationID
                                                                adUnitID:self.adUnitID
                                                                delegate:self];
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    [[FSSRewardedVideoAdMobManager sharedInstance] presentFromViewController:viewController];
}

- (NSString *)sdkVersion {
    return [NSString stringWithCString:(const char *)GoogleMobileAdsVersionString
                              encoding:NSUTF8StringEncoding];
}

#pragma mark FSSRewardedVideoAdMobManagerDelegate
- (void)didFailToLoadWithError:(nonnull NSError *)error {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                        code:FSSRewardedVideoAdErrorLoadFailed
                                                                                    userInfo:nil]
                                                     adnetworkError:error.code];
    });
}

- (void)didRewardUser {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
    });
}

- (void)rewardBasedVideoAdDidClose {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

- (void)rewardBasedVideoAdDidOpen {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)rewardBasedVideoAdDidReceiveAd {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)rewardBasedVideoOtherAdUnitProcessed {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                        code:FSSRewardedVideoAdErrorLoadFailed
                                                                                    userInfo:nil]
                                                     adnetworkError:FSSAdMobVideoErrorExtendendProcessingAnotherAd];
    });
}

@end
