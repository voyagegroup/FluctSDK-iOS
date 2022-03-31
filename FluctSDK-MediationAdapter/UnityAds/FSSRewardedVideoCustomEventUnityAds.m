//
//  FSSRewardedVideoCustomEventUnityAds.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventUnityAds.h"
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

@property (nonatomic) FSSConditionObserver *observer;

@end

static NSString *const FSSUnityAdsSupportVersion = @"9.0";

@implementation FSSRewardedVideoCustomEventUnityAds

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting {
    if (![FSSRewardedVideoCustomEventUnityAds isOSAtLeastVersion:FSSUnityAdsSupportVersion]) {
        return nil;
    }

    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:nil];
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
    self.observer = [[FSSConditionObserver alloc] initWithInterval:0.1f
        fallbackLimit:20
        completionHandler:^{
            dispatch_async(FSSWorkQueue(), ^{
                [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
            });
        }
        fallbackHandler:^{
            dispatch_async(FSSWorkQueue(), ^{
                NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                          code:FSSVideoErrorUnknown
                                                      userInfo:@{NSLocalizedDescriptionKey : @"Failed callback for rewardedVideoDidDisappearForCustomEvent"}];
                [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                                 fluctError:fluctError
                                                             adnetworkError:fluctError];
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
        NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain code:FSSVideoErrorTimeout userInfo:nil];
        [self.delegate rewardedVideoDidFailToLoadForCustomEvent:self
                                                     fluctError:fluctError
                                                 adnetworkError:fluctError];
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
    dispatch_async(FSSWorkQueue(), ^{
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
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state {
    __weak __typeof(self) weakSelf = self;

    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
    });

    [self.observer start];
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        NSError *unityAdsError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                     code:error
                                                 userInfo:@{NSLocalizedDescriptionKey : message}];
        [weakSelf clearTimer];
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        if (error == kUnityAdsErrorShowError) {
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorPlayFailed
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            return;
        }

        if (weakSelf.isInitialNotificationForAdapter) {
            weakSelf.isInitialNotificationForAdapter = NO;
            switch (error) {
            case kUnityAdsErrorInitializedFailed:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                code:FSSVideoErrorInitializeFailed
                                                                                            userInfo:@{NSLocalizedDescriptionKey : message}]
                                                             adnetworkError:unityAdsError];
                break;

            case kUnityAdsErrorInvalidArgument:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                code:FSSVideoErrorBadRequest
                                                                                            userInfo:@{NSLocalizedDescriptionKey : message}]
                                                             adnetworkError:unityAdsError];
                break;

            default:
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                code:FSSVideoErrorUnknown
                                                                                            userInfo:@{NSLocalizedDescriptionKey : message}]
                                                             adnetworkError:unityAdsError];
                break;
            }
        }
    });
}

- (void)unityAdsWillAppear {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
    });
}

- (void)unityAdsNoFill {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf clearTimer];
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        weakSelf.isInitialNotificationForAdapter = NO;
        NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:FSSVideoErrorNoAds
                                              userInfo:@{NSLocalizedDescriptionKey : @"no ad"}];
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:fluctError
                                                     adnetworkError:fluctError];
    });
}

@end
