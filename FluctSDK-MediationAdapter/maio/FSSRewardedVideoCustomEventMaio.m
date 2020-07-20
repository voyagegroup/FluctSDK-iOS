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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting {

    if (![FSSRewardedVideoCustomEvent isOSAtLeastVersion:FSSMaioSupportVersion]) {
        return nil;
    }

    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:nil];

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
                                                     fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                    code:FSSVideoErrorTimeout
                                                                                userInfo:nil]
                                                 adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                    code:MaioFailReasonExtendTimeout
                                                                                userInfo:@{NSLocalizedDescriptionKey : @"timeout."}]];
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

    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
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
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
    });
}

- (void)maioDidClickAd:(NSString *)zoneId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:self];
    });
}

- (void)maioDidCloseAd:(NSString *)zoneId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSFullscreenVideoWorkQueue(), ^{
        [self clearTimer];
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;

        NSError *adnwError = [self convertADNWErrorFromFailReason:reason];

        //error after initialization
        if (reason == MaioFailReasonVideoPlayback) {
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorPlayFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:adnwError];
            return;
        }

        //initialization error
        if (weakSelf.isInitialNotificationForAdapter) {
            weakSelf.isInitialNotificationForAdapter = NO;

            switch (reason) {
            case MaioFailReasonAdStockOut:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                code:FSSVideoErrorNoAds
                                                                                            userInfo:nil]
                                                             adnetworkError:adnwError];
                break;
            case MaioFailReasonUnknown:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                code:FSSVideoErrorUnknown
                                                                                            userInfo:nil]
                                                             adnetworkError:adnwError];
            default:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                code:FSSVideoErrorLoadFailed
                                                                                            userInfo:nil]
                                                             adnetworkError:adnwError];
                break;
            }
        }
    });
}

- (NSError *)convertADNWErrorFromFailReason:(MaioFailReason)failReason {
    NSString *message = @"unkonw.";
    switch (failReason) {
    case MaioFailReasonUnknown:
        message = @"unkonw.";
        break;
    case MaioFailReasonAdStockOut:
        message = @"ad stock out.";
        break;
    case MaioFailReasonNetworkConnection:
        message = @"network connection.";
        break;
    case MaioFailReasonNetworkClient:
        message = @"network client.";
        break;
    case MaioFailReasonNetworkServer:
        message = @"network server.";
        break;
    case MaioFailReasonSdk:
        message = @"sdk.";
        break;
    case MaioFailReasonDownloadCancelled:
        message = @"download cancelled.";
        break;
    case MaioFailReasonVideoPlayback:
        message = @"video playback.";
        break;
    case MaioFailReasonIncorrectMediaId:
        message = @"incorrect media id.";
        break;
    case MaioFailReasonIncorrectZoneId:
        message = @"incorrect zone id.";
        break;
    case MaioFailReasonNotFoundViewContext:
        message = @"not found view context.";
        break;
    }
    return [NSError errorWithDomain:FSSVideoErrorSDKDomain
                               code:failReason
                           userInfo:@{NSLocalizedDescriptionKey : message}];
}

@end
