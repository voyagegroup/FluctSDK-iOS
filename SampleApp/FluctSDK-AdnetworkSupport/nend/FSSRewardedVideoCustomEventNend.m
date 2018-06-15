//
//  FSSRewardedVideoCustomEventNend.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventNend.h"
#import <NendAd/NendAd.h>

typedef NS_ENUM(NSInteger, NADRewardedVideoErrorExtend) {
    NADRewardedVideoErrorExtendPlayFailed = -1
};

@interface FSSRewardedVideoCustomEventNend () <NADRewardedVideoDelegate>

@property (nonatomic) NADRewardedVideo *nendRewardedVideo;

@end

static NSString *const FSSNendSupportVersion = @"8.1";

@implementation FSSRewardedVideoCustomEventNend

+ (NADRewardedVideo *)initializeNendSDKWithSpotId:(NSString *)spotId apiKey:(NSString *)apiKey {
    return [[NADRewardedVideo alloc] initWithSpotId:spotId apiKey:apiKey];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate testMode:(BOOL)testMode debugMode:(BOOL)debugMode targeting:(FSSAdRequestTargeting *)targeting {
    if (![FSSRewardedVideoCustomEventNend shouldInitNendSDKWithSystemVersion:UIDevice.currentDevice.systemVersion]) {
        return nil;
    }

    self = [super initWithDictionary:dictionary delegate:delegate testMode:testMode debugMode:debugMode targeting:nil];

    _nendRewardedVideo = [FSSRewardedVideoCustomEventNend initializeNendSDKWithSpotId:dictionary[@"spot_id"] apiKey:dictionary[@"api_key"]];
    _nendRewardedVideo.delegate = self;
    _nendRewardedVideo.userFeature = [FSSRewardedVideoCustomEventNend generateUserFeatureWithTargeting:targeting];

    return self;
}

+ (BOOL)shouldInitNendSDKWithSystemVersion:(NSString *)systemVersion {
    return [systemVersion compare:FSSNendSupportVersion options:NSNumericSearch] != NSOrderedAscending;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    if (!self.nendRewardedVideo.isReady) {
        [self.nendRewardedVideo loadAd];
        _adnwStatus = FSSRewardedVideoADNWStatusLoading;
    } else {
        _adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [self.delegate rewardedVideoDidLoadForCustomEvent:self];
    }
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return _adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    if (self.nendRewardedVideo.isReady) {
        [self.nendRewardedVideo showAdFromViewController:viewController];
        [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    } else {
        NSError *error = [NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain code:FSSRewardedVideoAdErrorNotReady userInfo:nil];
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self fluctError:error adnetworkError:-1];
    }
}

// nend SDK not support api for get sdk version
- (NSString *)sdkVersion {
    return @"";
}

#pragma mark NADRewardedVideoDelegate

- (void)nadRewardVideoAdDidReceiveAd:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        _adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)nadRewardVideoAd:(NADRewardedVideo *)nadRewardedVideoAd didFailToLoadWithError:(NSError *)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        _adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                        code:[self rewardedVideoErrorCodeWithError:error]
                                                                                    userInfo:nil]
                                                     adnetworkError:error.code];
    });
}

- (FSSRewardedVideoErrorCode)rewardedVideoErrorCodeWithError:(NSError *)error {
    switch (error.code) {
    case 204:
        return FSSRewardedVideoAdErrorNoAds;

    case 400:
        return FSSRewardedVideoAdErrorBadRequest;

    default:
        return FSSRewardedVideoAdErrorLoadFailed;
    }
}

- (void)nadRewardVideoAdDidFailedToPlay:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        _adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                        code:FSSRewardedVideoAdErrorPlayFailed
                                                                                    userInfo:nil]
                                                     adnetworkError:NADRewardedVideoErrorExtendPlayFailed];
    });
}

- (void)nadRewardVideoAdDidOpen:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)nadRewardVideoAdDidCompletePlaying:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
    });
}

- (void)nadRewardVideoAdDidClose:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

- (void)nadRewardVideoAdDidClickAd:(NADRewardedVideo *)nadRewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:weakSelf];
    });
}

- (void)nadRewardVideoAd:(NADRewardedVideo *)nadRewardedVideoAd didReward:(NADReward *)reward {
}

+ (NADUserFeature *)generateUserFeatureWithTargeting:(FSSAdRequestTargeting *)targeting {
    if (!targeting) {
        return nil;
    }

    NADUserFeature *feature = [FSSRewardedVideoCustomEventNend userFeature];

    if (targeting.gender == FSSGenderMale) {
        feature.gender = NADGenderMale;
    } else if (targeting.gender == NADGenderFemale) {
        feature.gender = NADGenderFemale;
    }

    if (targeting.age) {
        feature.age = targeting.age;
    }

    if (targeting.birthday) {
        NSDateComponents *components = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:targeting.birthday];
        [feature setBirthdayWithYear:components.year month:components.month day:components.day];
    }

    return feature;
}

+ (NADUserFeature *)userFeature {
    return [NADUserFeature new];
}
@end
