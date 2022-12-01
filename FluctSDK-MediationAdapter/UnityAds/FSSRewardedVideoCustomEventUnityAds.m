//
//  FSSRewardedVideoCustomEventUnityAds.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventUnityAds.h"
#import "FSSUnityAds.h"
#import "FSSUnityAdsManager.h"
#import <UnityAds/UnityAds.h>

static const NSInteger timeoutSecond = 30;

@interface FSSRewardedVideoCustomEventUnityAds () <FSSUnityAdsManagerDelegate, UnityAdsShowDelegate>
@property (nonatomic, copy) NSString *gameID;
@property (nonatomic, copy) NSString *placementID;
@property (nonatomic) NSTimer *timeoutTimer;
@property (nonatomic) FSSUnityAdsManager *unityAdsManager;
@property (nonatomic) id<FSSUnityAdsProtocol> unityAds;
@end

@implementation FSSRewardedVideoCustomEventUnityAds

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting {
    return [self initWithDictionary:dictionary
                           delegate:delegate
                           testMode:testMode
                          debugMode:debugMode
                          skippable:skippable
                          targeting:nil
                    unityAdsManager:[FSSUnityAdsManager sharedInstanceWithUnityAds:[FSSUnityAds new]]
                           unityAds:[FSSUnityAds new]];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                   unityAdsManager:(FSSUnityAdsManager *)unityAdsManager
                          unityAds:(id<FSSUnityAdsProtocol>)unityAds {
    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:nil];

    self.gameID = dictionary[@"game_id"];
    self.placementID = dictionary[@"placement_id"];
    self.unityAdsManager = unityAdsManager;
    self.unityAds = unityAds;

    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    // if target placement id could not complete load, call load failed
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeoutSecond
                                                         target:self
                                                       selector:@selector(timeout)
                                                       userInfo:nil
                                                        repeats:NO];

    [self.unityAdsManager loadWithGameId:self.gameID
                                testMode:self.testMode
                               debugMode:self.debugMode
                             placementId:self.placementID
                                delegate:self];
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    [self.unityAds show:viewController placementId:self.placementID showDelegate:self];
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
}

- (NSString *)sdkVersion {
    return [UnityAds getVersion];
}

- (void)timeout {
    [self clearTimer];
    if (self.adnwStatus == FSSRewardedVideoADNWStatusLoading) {
        self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:FSSVideoErrorTimeout
                                              userInfo:nil];
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

#pragma mark FSSUnityAdsManagerDelegate

- (void)unityAdsFailedToInitializeWithFluctError:(NSError *)fluctError
                                  adnetworkError:(NSError *)adnetworkError {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf clearTimer];
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:fluctError
                                                     adnetworkError:adnetworkError];
    });
}

#pragma mark UnityAdsLoadDelegate(FSSUnityAdsManagerDelegate)

- (void)unityAdsAdLoaded:(NSString *)placementId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf clearTimer];
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)unityAdsAdFailedToLoad:(NSString *)placementId
                     withError:(UnityAdsLoadError)error
                   withMessage:(NSString *)message {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf clearTimer];
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        NSError *unityAdsError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                     code:error
                                                 userInfo:@{NSLocalizedDescriptionKey : message}];
        switch (error) {
        case kUnityAdsLoadErrorInitializeFailed:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorInitializeFailed
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        case kUnityAdsLoadErrorInternal:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorLoadFailed
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        case kUnityAdsLoadErrorInvalidArgument:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorBadRequest
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        case kUnityAdsLoadErrorNoFill:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorNoAds
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];

            break;
        case kUnityAdsLoadErrorTimeout:
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorTimeout
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
    });
}

#pragma mark UnityAdsShowDelegate

- (void)unityAdsShowClick:(nonnull NSString *)placementId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:weakSelf];
    });
}

- (void)unityAdsShowComplete:(nonnull NSString *)placementId withFinishState:(UnityAdsShowCompletionState)state {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        // スキップ不可の広告でスキップされたら再生失敗にする
        if (!self.skippable && state == kUnityShowCompletionStateSkipped) {
            NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                      code:FSSVideoErrorUnknown
                                                  userInfo:@{NSLocalizedDescriptionKey : @"Failed to play the ad completely because the ad skipped"}];
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:fluctError
                                                         adnetworkError:fluctError];
            return;
        }
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

- (void)unityAdsShowFailed:(nonnull NSString *)placementId
                 withError:(UnityAdsShowError)error
               withMessage:(nonnull NSString *)message {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        NSError *unityAdsError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                     code:error
                                                 userInfo:@{NSLocalizedDescriptionKey : message}];
        switch (error) {
        case kUnityShowErrorNotInitialized:
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorInitializeFailed
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        case kUnityShowErrorNotReady:
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorNotReady
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        case kUnityShowErrorVideoPlayerError:
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorPlayFailed
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        case kUnityShowErrorInvalidArgument:
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorBadRequest
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        case kUnityShowErrorNoConnection:
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorNotConnectedToInternet
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        case kUnityShowErrorAlreadyShowing:
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorExpired
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        case kUnityShowErrorInternalError:
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorPlayFailed
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        default:
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorUnknown
                                                                                        userInfo:@{NSLocalizedDescriptionKey : message}]
                                                         adnetworkError:unityAdsError];
            break;
        }
    });
}

- (void)unityAdsShowStart:(nonnull NSString *)placementId {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

@end
