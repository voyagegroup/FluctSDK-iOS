//
//  FSSRewardedVideoAdnetworkActivation.h
//  FluctSDK
//
//  Copyright © 2019年 fluct, Inc. All rights reserved.
//

#import "FSSFullscreenVideoAdnetworkActivation.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSSRewardedVideoAdnetworkActivation : NSObject <FSSFullscreenVideoAdnetworkActivation>

@property (class, nonatomic, readonly) FSSRewardedVideoAdnetworkActivation *defaultAdnetworkActivation NS_SWIFT_NAME(default);

/**
 * Activation setting for AdColony.
 * Required to include `FSSRewardedVideoCustomEventAdColony` in project.
 */
@property (nonatomic, getter=isAdColonyActivated) BOOL adColonyActivated;

/**
 * Activation setting for AdCorsa.
 * Required to include `FSSRewardedVideoCustomEventAdCorsa` in project.
 */
@property (nonatomic, getter=isAdCorsaActivated) BOOL adCorsaActivated;

/**
 * Activation setting for AppLovin.
 * Required to include `FSSRewardedVideoCustomEventAppLovin` in project.
 */
@property (nonatomic, getter=isAppLovinActivated) BOOL appLovinActivated;

/**
 * Activation setting for Five.
 * Required to include `FSSRewardedVideoCustomEventFive` in project.
 */
@property (nonatomic, getter=isFiveActivated) BOOL fiveActivated;

/**
 * Activation setting for fluct.
 */
@property (nonatomic, getter=isFluctActivated) BOOL fluctActivated;

/**
 * Activation setting for maio.
 * Required to include `FSSRewardedVideoCustomEventMaio` in project.
 */
@property (nonatomic, getter=isMaioActivated) BOOL maioActivated;

/**
 * Activation setting for nend.
 * Required to include `FSSRewardedVideoCustomEventNend` in project.
 */
@property (nonatomic, getter=isNendActivated) BOOL nendActivated;

/**
 * Activation setting for Pangle.
 * Required to include `FSSRewardedVideoCustomEventPangle` in project.
 */
@property (nonatomic, getter=isPangleActivated) BOOL pangleActivated;

/**
 * Activation setting for Tapjoy.
 * Required to include `FSSRewardedVideoCustomEventTapjoy` in project.
 */
@property (nonatomic, getter=isTapjoyActivated) BOOL tapjoyActivated;

/**
 * Activation setting for UnityAds.
 * Required to include `FSSRewardedVideoCustomEventUnityAds` in project.
 */
@property (nonatomic, getter=isUnityAdsActivated) BOOL unityAdsActivated;

- (NSString *)description;

- (NSDictionary<NSString *, id> *)dictionary;

- (BOOL)hasDeactivatedAdnetwork;

@end

NS_ASSUME_NONNULL_END
