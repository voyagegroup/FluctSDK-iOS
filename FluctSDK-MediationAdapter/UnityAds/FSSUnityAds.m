//
//  FSSUnityAds.m
//  FluctSDK
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

#import "FSSUnityAds.h"

@interface FSSUnityAds () <FSSUnityAdsProtocol>

- (void)initialize:(NSString *)gameId
                  testMode:(BOOL)testMode
    initializationDelegate:(nullable id<UnityAdsInitializationDelegate>)initializationDelegate;

- (void)load:(NSString *)placementId
    loadDelegate:(nullable id<UnityAdsLoadDelegate>)loadDelegate;

- (void)show:(UIViewController *)viewController
     placementId:(NSString *)placementId
    showDelegate:(nullable id<UnityAdsShowDelegate>)showDelegate;

@end

@implementation FSSUnityAds

- (void)initialize:(NSString *)gameId
                  testMode:(BOOL)testMode
    initializationDelegate:(nullable id<UnityAdsInitializationDelegate>)initializationDelegate {
    UADSMediationMetaData *mediationMetaData = [[UADSMediationMetaData alloc] init];
    [mediationMetaData setName:@"fluct"];
    [mediationMetaData setVersion:[FluctSDK version]];
    [mediationMetaData commit];
    [UnityAds initialize:gameId testMode:testMode initializationDelegate:initializationDelegate];
}

- (void)load:(NSString *)placementId
    loadDelegate:(nullable id<UnityAdsLoadDelegate>)loadDelegate {
    [UnityAds load:placementId loadDelegate:loadDelegate];
}

- (void)show:(UIViewController *)viewController
     placementId:(NSString *)placementId
    showDelegate:(nullable id<UnityAdsShowDelegate>)showDelegate {
    [UnityAds show:viewController placementId:placementId showDelegate:showDelegate];
}

@end
