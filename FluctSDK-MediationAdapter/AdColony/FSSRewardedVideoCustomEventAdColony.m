//
// FluctSDK
//
// Copyright (c) 2018 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventAdColony.h"
#import "FSSRewardedVideoAdColonyManager.h"

typedef NS_ENUM(NSInteger, AdColonyVideoErrorExtendend) {
    AdColonyVideoErrorExtendendTimeout = -1,
    AdColonyVideoErrorExtendendExpired = -2
};

static const NSInteger timeoutSecond = 3;
static NSString *const FSSAdColonySupportVersion = @"9.0";

@interface FSSRewardedVideoCustomEventAdColony () <FSSRewardedVideoAdColonyManagerDelegate>
@property (nonatomic, copy) NSString *zoneId;
@property (nonatomic) NSTimer *timeoutTimer;
@end

@implementation FSSRewardedVideoCustomEventAdColony

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting {

    if (![FSSRewardedVideoCustomEvent isOSAtLeastVersion:FSSAdColonySupportVersion]) {
        return nil;
    }

    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:nil];

    if (self) {
        self.zoneId = dictionary[@"zone_id"];
        [[FSSRewardedVideoAdColonyManager sharedInstance] configureWithAppId:dictionary[@"app_id"]
                                                                     zoneIDs:dictionary[@"all_zone_ids"]
                                                                    testMode:testMode
                                                                       debug:debugMode];
    }
    return self;
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeoutSecond
                                                         target:self
                                                       selector:@selector(timeout)
                                                       userInfo:nil
                                                        repeats:NO];
    [[FSSRewardedVideoAdColonyManager sharedInstance] loadRewardedVideoWithZoneId:self.zoneId
                                                                         delegate:self];
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    [[FSSRewardedVideoAdColonyManager sharedInstance] presentRewardedVideoAdFromViewController:viewController
                                                                                        zoneID:self.zoneId];
}

- (NSString *)sdkVersion {
    return [AdColony getSDKVersion];
}

- (void)timeout {
    [self clearTimer];
    if (self.adnwStatus == FSSRewardedVideoADNWStatusLoading) {
        self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [self.delegate rewardedVideoDidFailToLoadForCustomEvent:self
                                                     fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                    code:FSSVideoErrorTimeout
                                                                                userInfo:nil]
                                                 adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                    code:AdColonyVideoErrorExtendendTimeout
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

#pragma mark - FSSRewardedVideoAdColonyManagerDelegate
- (void)adColonyInterstitialDidLoad {
    [self clearTimer];

    if (self.adnwStatus == FSSRewardedVideoADNWStatusNotDisplayable) {
        //already timeout. do nothing.
        return;
    }

    self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
    [self.delegate rewardedVideoDidLoadForCustomEvent:self];
}

- (void)adColonyInterstitialDidFailToLoad:(AdColonyAdRequestError *)error {
    [self clearTimer];

    if (self.adnwStatus == FSSRewardedVideoADNWStatusNotDisplayable) {
        //already timeout. do nothing.
        return;
    }
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;

    NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                              code:[self errorCodeForAdColonyRequestError:error.code]
                                          userInfo:error.userInfo];
    [self.delegate rewardedVideoDidFailToLoadForCustomEvent:self
                                                 fluctError:fluctError
                                             adnetworkError:error];
}

- (void)adColonyInterstitialWillOpen {
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

- (void)adColonyInterstitialDidClose {
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

- (void)rewarded {
    [self.delegate rewardedVideoShouldRewardForCustomEvent:self];
}

- (void)adColonyInterstitialDidReceiveClick {
    [self.delegate rewardedVideoDidClickForCustomEvent:self];
}

- (void)adColonyInterstitialExpired {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                 fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                code:FSSVideoErrorExpired
                                                                            userInfo:@{NSLocalizedDescriptionKey : @"expired ad"}]
                                             adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                code:AdColonyVideoErrorExtendendTimeout
                                                                            userInfo:@{NSLocalizedDescriptionKey : @"expired ad."}]];
}

- (FSSVideoError)errorCodeForAdColonyRequestError:(AdColonyRequestError)adColonyRequestError {
    switch (adColonyRequestError) {
    case AdColonyRequestErrorNoFillForRequest:
        return FSSVideoErrorNoAds;
    case AdColonyRequestErrorSkippedRequest:
    case AdColonyRequestErrorUnready:
        return FSSVideoErrorLoadFailed;
    case AdColonyRequestErrorInvalidRequest:
        return FSSVideoErrorBadRequest;
    default:
        return FSSVideoErrorUnknown;
    }
}
@end
