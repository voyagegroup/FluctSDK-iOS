//
//  FSSUnityAds.h
//  FluctSDK
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

#import <FluctSDK/FluctSDK.h>
#import <UnityAds/UnityAds.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FSSUnityAdsProtocol

- (void)initialize:(NSString *)gameId
                  testMode:(BOOL)testMode
    initializationDelegate:(nullable id<UnityAdsInitializationDelegate>)initializationDelegate;

- (void)load:(NSString *)placementId
    loadDelegate:(nullable id<UnityAdsLoadDelegate>)loadDelegate;

- (void)show:(UIViewController *)viewController
     placementId:(NSString *)placementId
    showDelegate:(nullable id<UnityAdsShowDelegate>)showDelegate;

@end

@interface FSSUnityAds : NSObject <FSSUnityAdsProtocol>

- (void)initialize:(NSString *)gameId
                  testMode:(BOOL)testMode
    initializationDelegate:(nullable id<UnityAdsInitializationDelegate>)initializationDelegate;

- (void)load:(NSString *)placementId
    loadDelegate:(nullable id<UnityAdsLoadDelegate>)loadDelegate;

- (void)show:(UIViewController *)viewController
     placementId:(NSString *)placementId
    showDelegate:(nullable id<UnityAdsShowDelegate>)showDelegate;

@end

NS_ASSUME_NONNULL_END
