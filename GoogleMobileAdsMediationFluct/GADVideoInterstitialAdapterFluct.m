//
//  GADVideoInterstitialAdapterFluct.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "GADVideoInterstitialAdapterFluct.h"
#import "GADAdapterFluctVideoDelegateProxy.h"
#import "GADMFluctError.h"
@import FluctSDK;

@interface GADVideoInterstitialAdapterFluct () <GADAdapterFluctVideoDelegateProxyItem>

@property (nonatomic, nullable) NSString *groupID;
@property (nonatomic, nullable) NSString *unitID;

@end

@implementation GADVideoInterstitialAdapterFluct

@synthesize delegate;

- (void)requestInterstitialAdWithParameter:(NSString *)serverParameter
                                     label:(NSString *)serverLabel
                                   request:(GADCustomEventRequest *)request {
    NSError *error = nil;
    if (![self setupAdapterWithParameter:serverParameter error:&error]) {
        [self.delegate customEventInterstitial:self didFailAd:error];
        return;
    }

    [[GADAdapterFluctVideoDelegateProxy sharedInstance] registerDelegate:self groupId:self.groupID unitId:self.unitID];
    FSSRewardedVideo.sharedInstance.delegate = GADAdapterFluctVideoDelegateProxy.sharedInstance;
    [[FSSRewardedVideo sharedInstance] loadRewardedVideoWithGroupId:self.groupID unitId:self.unitID];
}

- (void)presentFromRootViewController:(UIViewController *)rootViewController {
    if ([[FSSRewardedVideo sharedInstance] hasAdAvailableForGroupId:self.groupID unitId:self.unitID]) {
        [[FSSRewardedVideo sharedInstance] presentRewardedVideoAdForGroupId:self.groupID
                                                                     unitId:self.unitID
                                                         fromViewController:rootViewController];
    }
}

#pragma mark - setup
- (BOOL)setupAdapterWithParameter:(NSString *)serverParameter error:(NSError **)error {
    NSArray<NSString *> *ids = [serverParameter componentsSeparatedByString:@","];
    if (ids.count != 2) {
        if (error) {
            *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorInvalidCustomParameters
                                     userInfo:@{}];
        }
        return NO;
    }

    self.groupID = ids.firstObject;
    self.unitID = ids.lastObject;
    return YES;
}

#pragma mark - GADAdapterFluctVideoDelegateProxyItem
- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    [self.delegate customEventInterstitialDidReceiveAd:self];
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.delegate customEventInterstitialWillPresent:self];
}

- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    // nothing
}

- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.delegate customEventInterstitialWillDismiss:self];
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.delegate customEventInterstitialDidDismiss:self];
}

@end
