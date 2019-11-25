//
// FluctSDK
//
// Copyright (c) 2018 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventAdCorsa.h"
#import "GlossomAds/GlossomAds.h"

typedef NS_ENUM(NSInteger, AdCorsaVideoErrorExtendend) {
    AdCorsaVideoErrorExtendendTimeout = -1,
    AdCorsaVideoErrorExtendendNotReady = -2,
};

static const NSTimeInterval timeoutSecond = 5;

@interface FSSRewardedVideoCustomEventAdCorsa () <GlossomAdsDelegate, GlossomAdsVideoAdDelegate, GlossomAdsRewardAdDelegate, GlossomAdsInterstitialAdDelegate>
@property (nonatomic, copy) NSString *zoneId;
@property (nonatomic) NSTimer *timeoutTimer;
@end

@implementation FSSRewardedVideoCustomEventAdCorsa

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         targeting:(FSSAdRequestTargeting *)targeting {

    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           targeting:nil];

    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [GlossomAds configure:dictionary[@"app_id"] zoneIds:dictionary[@"all_zone_ids"] clientOptions:@{}];
        });
        _zoneId = dictionary[@"zone_id"];
        [GlossomAds setDelegate:self forZone:_zoneId];
    }
    return self;
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    if ([GlossomAds isReady:self.zoneId]) {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [self.delegate rewardedVideoDidLoadForCustomEvent:self];
        return;
    }

    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;

    [GlossomAds startWithZoneIds:@[ self.zoneId ]];
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeoutSecond
                                                         target:self
                                                       selector:@selector(timeout)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    if ([GlossomAds isReady:self.zoneId]) {
        [GlossomAds showRewardVideo:self.zoneId delegate:self];
        return;
    }

    // AdCorsaVideoErrorExtendendNotReady
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                 fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                code:FSSRewardedVideoAdErrorNotReady
                                                                            userInfo:nil]
                                             adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                code:AdCorsaVideoErrorExtendendNotReady
                                                                            userInfo:@{NSLocalizedDescriptionKey : @"not ready."}]];
}

- (NSString *)sdkVersion {
    return @"";
}

- (void)timeout {
    [self clearTimer];
    if (self.adnwStatus == FSSRewardedVideoADNWStatusLoading) {
        self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [self.delegate rewardedVideoDidFailToLoadForCustomEvent:self
                                                     fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                    code:FSSRewardedVideoAdErrorTimeout
                                                                                userInfo:nil]
                                                 adnetworkError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                    code:AdCorsaVideoErrorExtendendTimeout
                                                                                userInfo:@{NSLocalizedDescriptionKey : @"time out."}]];
    }
}

- (void)clearTimer {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
}

- (void)dealloc {
    [self clearTimer];
}

#pragma mark - GlossomAdsDelegate

- (void)onAdAvailabilityChange:(BOOL)available inZone:(nonnull NSString *)zoneId {
    if (self.adnwStatus == FSSRewardedVideoADNWStatusLoading && available) {
        [self clearTimer];
        self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [self.delegate rewardedVideoDidLoadForCustomEvent:self];
    }
}

#pragma mark - GlossomAdsRewardAdDelegate

- (void)onGlossomAdsReward:(NSString *)zoneId success:(BOOL)success {
    if (success) {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(FSSRewardedVideoWorkQueue(), ^{
            [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
        });
    }
}

#pragma mark - GlossomAdsVideoAdDelegate

- (void)onGlossomAdsVideoFinish:(NSString *)zoneId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
    });
}

#pragma mark - GlossomAdsInterstitialAdDelegate

- (void)onGlossomAdsAdShow:(NSString *)zoneId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)onGlossomAdsAdClose:(NSString *)zoneId isShown:(BOOL)shown {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

@end
