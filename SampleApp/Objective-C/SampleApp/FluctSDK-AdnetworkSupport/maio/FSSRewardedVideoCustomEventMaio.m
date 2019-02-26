//
//  FSSRewardedVideoCustomEventMaio.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventMaio.h"

@interface FSSRewardedVideoCustomEventMaio ()

@property (nonatomic, copy) NSString *zoneID;
@property (nonatomic) NSTimer *timeoutTimer;
@property (nonatomic) BOOL isInitialNotificationForAdapter;
@end

static const NSInteger timeoutSecond = 30;

static NSString *const FSSMaioSupportVersion = @"8.0";

@implementation FSSRewardedVideoCustomEventMaio

- (instancetype)initWithDictionary:(NSDictionary *)dictionary delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate testMode:(BOOL)testMode debugMode:(BOOL)debugMode targeting:(FSSAdRequestTargeting *)targeting {
    if (![FSSRewardedVideoCustomEvent isOSAtLeastVersion:FSSMaioSupportVersion]) {
        return nil;
    }

    self = [super initWithDictionary:dictionary delegate:delegate testMode:testMode debugMode:debugMode targeting:nil];
    if (!self) {
        return nil;
    }
    _zoneID = dictionary[@"zone_id"];
    _isInitialNotificationForAdapter = YES;
    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeoutSecond
                                                         target:self
                                                       selector:@selector(timeout)
                                                       userInfo:nil
                                                        repeats:NO];
    [[FSSRewardedVideoMaioManager sharedInstance] loadRewardedVideoWithDictionary:dictionary
                                                                         delegate:self
                                                                         testMode:self.testMode];
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    [[FSSRewardedVideoMaioManager sharedInstance] presentRewardedVideoAdFromViewController:viewController
                                                                                    zoneId:self.zoneID];
}

- (NSString *)sdkVersion {
    return [Maio sdkVersion];
}

- (void)timeout {
    [self clearTimer];
    if (self.isInitialNotificationForAdapter) {
        self.isInitialNotificationForAdapter = NO;
        self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [self.delegate rewardedVideoDidFailToLoadForCustomEvent:self
                                                     fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                    code:FSSRewardedVideoAdErrorBadRequest
                                                                                userInfo:nil]
                                                 adnetworkError:MaioFailReasonExtendTimeout];
    }
}

- (void)clearTimer {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
}

- (void)dealloc {
    [self clearTimer];
}

#pragma mark FSSRewardedVideoMaioManagerDelegate
- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    __weak __typeof(self) weakSelf = self;

    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf clearTimer];

        if (self.isInitialNotificationForAdapter) {
            weakSelf.isInitialNotificationForAdapter = NO;
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
            [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
        }
    });
}

- (void)maioWillStartAd:(NSString *)zoneId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
    });
}

- (void)maioDidClickAd:(NSString *)zoneId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:self];
    });
}

- (void)maioDidCloseAd:(NSString *)zoneId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [self clearTimer];
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;

        //error after initialization
        if (reason == MaioFailReasonVideoPlayback) {
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorPlayFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:reason];
            return;
        }

        //initialization error
        if (weakSelf.isInitialNotificationForAdapter) {
            weakSelf.isInitialNotificationForAdapter = NO;

            switch (reason) {
            case MaioFailReasonAdStockOut:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                                code:FSSRewardedVideoAdErrorNoAds
                                                                                            userInfo:nil]
                                                             adnetworkError:reason];
                break;
            case MaioFailReasonUnknown:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                                code:FSSRewardedVideoAdErrorUnknown
                                                                                            userInfo:nil]
                                                             adnetworkError:reason];
            default:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                                code:FSSRewardedVideoAdErrorLoadFailed
                                                                                            userInfo:nil]
                                                             adnetworkError:reason];
                break;
            }
        }
    });
}

@end
