//
//  GADRewardedVideoAdapterFluctStarter.m
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "GADRewardedVideoAdapterFluctStarter.h"
#import "GADAdapterFluctVideoDelegateProxy.h"
#import "GADMAdapterFluctExtras.h"
#import "GADMFluctError.h"
#import "GADMediationAdapterFluctUtil.h"
#import <FluctSDK/FluctSDK.h>
#import <stdatomic.h>

@interface GADRewardedVideoAdapterFluctStarter () <GADAdapterFluctVideoDelegateProxyItem, FSSRewardedVideoCustomEventStarterDelegate>
@property (nonatomic, nullable, copy) GADMediationRewardedLoadCompletionHandler loadCompletionHandler;
@property (nonatomic, nullable, weak) id<GADMediationRewardedAdEventDelegate> adEventDelegate;

@property (nonatomic, nullable) FSSRewardedVideoCustomEventStarter *starter;
@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *unitID;
@property (nonatomic, nullable, copy) NSString *pricePoint;
@end

@implementation GADRewardedVideoAdapterFluctStarter

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {

    [GADMediationAdapterFluctUtil setUpWithConfiguration:configuration
                                       completionHandler:completionHandler];
}

+ (GADVersionNumber)adSDKVersion {
    return [GADMediationAdapterFluctUtil adSDKVersion];
}

+ (GADVersionNumber)adapterVersion {
    return [GADMediationAdapterFluctUtil adapterVersion];
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return [GADMAdapterFluctExtras class];
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {

    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationRewardedLoadCompletionHandler
        originalCompletionHandler = [completionHandler copy];

    self.loadCompletionHandler = ^id<GADMediationRewardedAdEventDelegate>(
        _Nullable id<GADMediationRewardedAd> ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }

        id<GADMediationRewardedAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
        }

        originalCompletionHandler = nil;

        return delegate;
    };

    NSError *error = nil;
    if (![self setupAdapterWithParameter:[adConfiguration.credentials.settings objectForKey:GADCustomEventParametersServer] error:&error]) {
        self.adEventDelegate = self.loadCompletionHandler(nil, error);
        return;
    }

    FSSConfigurationOptions *options = [FluctSDK currentConfigureOptions];
    options.mediationPlatformType = FSSMediationPlatformTypeGoogleMobileAds;
    options.mediationPlatformSDKVersion = [NSString stringWithFormat:@"%s", GoogleMobileAdsVersionString];
    [FluctSDK configureWithOptions:options];

    GADMAdapterFluctExtras *extras = adConfiguration.extras;
    FSSRewardedVideoSetting *setting = [FSSRewardedVideoSetting defaultSetting];
    if (extras.setting) {
        setting = extras.setting;
    }

    self.starter = [[FSSRewardedVideoCustomEventStarter alloc] initWithGroupId:self.groupID unitId:self.unitID pricePoint:self.pricePoint];
    self.starter.delegate = self;

    [[GADAdapterFluctVideoDelegateProxy sharedInstance] registerDelegate:self
                                                                 groupId:self.groupID
                                                                  unitId:self.unitID];
    [self.starter requestWithSetting:setting
                            delegate:GADAdapterFluctVideoDelegateProxy.sharedInstance
                         rtbDelegate:GADAdapterFluctVideoDelegateProxy.sharedInstance];
}

- (void)presentFromViewController:(UIViewController *)viewController {
    if ([self.starter hasAdAvailable]) {
        [self.starter presentAdFromViewController:viewController];
    } else {
        NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                             code:GADMFluctErrorHasNotAdAvailable
                                         userInfo:nil];
        [self.adEventDelegate didFailToPresentWithError:error];
    }
}

#pragma mark - setup

- (BOOL)setupAdapterWithParameter:(NSString *)serverParameter error:(NSError **)error {
    NSArray<NSString *> *ids = [serverParameter componentsSeparatedByString:@","];
    if (ids.count != 3) {
        if (error) {
            *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorInvalidCustomParameters
                                     userInfo:@{}];
        }
        return NO;
    }

    self.groupID = ids[0];
    self.unitID = ids[1];
    self.pricePoint = ids[2];
    return YES;
}

#pragma mark - FSSRewardedVideoCustomEventStarterDelegate

- (void)customEventNotFoundResponse:(FSSRewardedVideoCustomEventStarter *)customEvent {
    NSError *error = [NSError errorWithDomain:GADMFluctErrorDomain
                                         code:GADMFluctErrorInvalidCustomParameters
                                     userInfo:@{}];
    self.adEventDelegate = self.loadCompletionHandler(nil, error);
}

#pragma mark - GADAdapterFluctVideoDelegateProxyItem

- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    self.adEventDelegate = self.loadCompletionHandler(self, nil);
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    NSError *err = [NSError errorWithDomain:GADMFluctErrorDomain
                                       code:error.code
                                   userInfo:error.userInfo];
    self.adEventDelegate = self.loadCompletionHandler(nil, err);
}

- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate willPresentFullScreenView];
}

- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate didStartVideo];
}

- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    NSError *err = [NSError errorWithDomain:GADMFluctErrorDomain
                                       code:error.code
                                   userInfo:error.userInfo];
    [self.adEventDelegate didFailToPresentWithError:err];
}

- (void)rewardedVideoShouldRewardForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate didEndVideo];
    [self.adEventDelegate didRewardUser];
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate willDismissFullScreenView];
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate didDismissFullScreenView];
}

- (void)rewardedVideoDidClickForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    [self.adEventDelegate reportClick];
}

@end
