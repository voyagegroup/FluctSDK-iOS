//
//  FSSPangleLoadManager.h
//  FluctSDKApp
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

#import <FluctSDK/FluctSDK.h>
#import <PAGAdSDK/PAGAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FSSPangleLoadManagerDelegate
- (void)pangleFailedToInitializeWithFluctError:(NSError *)fluctError
                                adnetworkError:(NSError *)adnetworkError;
- (void)pangleRewardedAdDidLoad:(PAGRewardedAd *)rewardedAd;
- (void)pangleRewardedAdFailedToLoad:(NSError *)error;
@end

@interface FSSPangleLoadManager : NSObject
+ (instancetype)sharedInstance;
- (void)loadWithAppId:(NSString *)AppId
            debugMode:(BOOL)debugMode
               slotId:(NSString *)slotId
             delegate:(id<FSSPangleLoadManagerDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
