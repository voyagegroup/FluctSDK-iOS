//
//  FSSRewardedVideoCustomEventUnityAds.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventUnityAds.h"
#import "FSSRewardedVideoConditionObserver.h"
#import "FSSRewardedVideoUnityAdsManager.h"

/**
 * UnityAds SDK automatically downloads advertisements when rewarded video ad played
 * Since we do not want to notify did load delegate after automatic download,
 * notification of load completion by UnityAdsDelegate's unityAdsReady is done only once
 * When UnityAds SDK has been initialized, rewardedVideoDidLoadForCustomEvent call in loadRewardedVideoWithCreative
 */

static const NSInteger timeoutSecond = 30;

@interface FSSRewardedVideoCustomEventUnityAds () <FSSRewardedVideoUnityAdsManagerDelegate>

@property (nonatomic, copy) NSString *gameID;
@property (nonatomic, copy) NSString *placementID;
@property (nonatomic) NSTimer *timeoutTimer;
@property (nonatomic) BOOL isInitialNotificationForAdapter;
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic) FSSRewardedVideoConditionObserver *observer;

@end

@implementation FSSRewardedVideoCustomEventUnityAds

- (instancetype)initWithDictionary:(NSDictionary *)dictionary delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate testMode:(BOOL)testMode debugMode:(BOOL)debugMode targeting:(FSSAdRequestTargeting *)targeting {
    self = [super initWithDictionary:dictionary delegate:delegate testMode:testMode debugMode:debugMode targeting:nil];
    if (self != nil) {
        _isInitialNotificationForAdapter = YES;
    }
    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    self.gameID = dictionary[@"game_id"];
    self.placementID = dictionary[@"placement_id"];
    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    // if target placement id could not complete load, call load failed
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeoutSecond
                                                         target:self
                                                       selector:@selector(timeout)
                                                       userInfo:nil
                                                        repeats:NO];

    [[FSSRewardedVideoUnityAdsManager sharedInstance] loadRewardedVideoWithDictionary:dictionary
                                                                             delegate:self
                                                                             testMode:self.testMode
                                                                            debugMode:self.debugMode];
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    self.viewController = viewController;
    __weak __typeof(self) weakSelf = self;
    self.observer = [[FSSRewardedVideoConditionObserver alloc] initWithInterval:0.1f
        fallbackLimit:10
        completionHandler:^{
            dispatch_async(FSSRewardedVideoWorkQueue(), ^{
                [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
            });
        }
        fallbackHandler:^{
            dispatch_async(FSSRewardedVideoWorkQueue(), ^{
                [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                                code:FSSRewardedVideoAdErrorUnknown
                                                                                            userInfo:@{NSLocalizedDescriptionKey : @"Failed callback for rewardedVideoDidDisappearForCustomEvent"}]
                                                             adnetworkError:UnityAdsErrorExtendCallDidDisappearFailed];
            });
        }
        shouldCompletionCondition:^BOOL {
            return !weakSelf.viewController.presentedViewController;
        }];

    [[FSSRewardedVideoUnityAdsManager sharedInstance] presentRewardedVideoAdFromViewController:viewController
                                                                                   placementId:self.placementID];
}

- (NSString *)sdkVersion {
    return [UnityAds getVersion];
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
                                                 adnetworkError:UnityAdsErrorExtendTimeout];
    }
}

- (void)clearTimer {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
}

- (void)dealloc {
    [self clearTimer];
}

#pragma mark - FSSRewardedVideoUnityAdsManagerDelegate

- (void)unityAdsReady:(NSString *)placementId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf clearTimer];

        if (weakSelf.isInitialNotificationForAdapter) {
            weakSelf.isInitialNotificationForAdapter = NO;
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
            [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
        }
    });
}

- (void)unityAdsDidStart:(NSString *)placementId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state {
    __weak __typeof(self) weakSelf = self;

    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
    });

    [self.observer start];
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf clearTimer];
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        if (error == kUnityAdsErrorShowError) {
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorPlayFailed
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:error];
            return;
        }

        if (weakSelf.isInitialNotificationForAdapter) {
            weakSelf.isInitialNotificationForAdapter = NO;
            switch (error) {
            case kUnityAdsErrorInitializedFailed:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                                code:FSSRewardedVideoAdErrorInitializeFailed
                                                                                            userInfo:@{NSLocalizedDescriptionKey : message}]
                                                             adnetworkError:error];
                break;

            case kUnityAdsErrorInvalidArgument:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                                code:FSSRewardedVideoAdErrorBadRequest
                                                                                            userInfo:@{NSLocalizedDescriptionKey : message}]
                                                             adnetworkError:error];
                break;

            default:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                                code:FSSRewardedVideoAdErrorUnknown
                                                                                            userInfo:@{NSLocalizedDescriptionKey : message}]
                                                             adnetworkError:error];
                break;
            }
        }
    });
}

- (void)unityAdsDidClick:(NSString *)placementId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:weakSelf];
    });
}

- (void)unityAdsWillAppear {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
    });
}

- (void)unityAdsNoFill {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf clearTimer];
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        weakSelf.isInitialNotificationForAdapter = NO;
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                        code:FSSRewardedVideoAdErrorLoadFailed
                                                                                    userInfo:@{NSLocalizedDescriptionKey : @"no ad"}]
                                                     adnetworkError:UnityAdsErrorExtendNoFill];
    });
}

@end
