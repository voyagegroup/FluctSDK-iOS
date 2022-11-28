//
//  FSSUnityAdsManager.h
//  FluctSDK
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

#import "FSSUnityAds.h"
#import <FluctSDK/FluctSDK.h>
#import <UnityAds/UnityAds.h>

@protocol FSSUnityAdsManagerDelegate <UnityAdsLoadDelegate>
- (void)unityAdsFailedToInitializeWithFluctError:(NSError *)fluctError
                                  adnetworkError:(NSError *)adnetworkError;
@end

@interface FSSUnityAdsManager : NSObject
+ (instancetype)sharedInstanceWithUnityAds:(id<FSSUnityAdsProtocol>)unityAds;
- (void)loadWithGameId:(NSString *)gameId
              testMode:(BOOL)testMode
             debugMode:(BOOL)debugMode
           placementId:(NSString *)placementId
              delegate:(id<FSSUnityAdsManagerDelegate>)delegate;
@end
