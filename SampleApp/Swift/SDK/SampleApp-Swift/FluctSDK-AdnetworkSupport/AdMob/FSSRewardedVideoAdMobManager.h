//
//  FSSRewardedVideoAdMobManager.h
//  FluctSDK
//
//  Copyright © 2019年 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FSSRewardedVideoAdMobManagerDelegate <NSObject>
- (void)didRewardUser;
- (void)didFailToLoadWithError:(NSError *)error;
- (void)rewardBasedVideoAdDidReceiveAd;
- (void)rewardBasedVideoAdDidOpen;
- (void)rewardBasedVideoAdDidClose;
- (void)rewardBasedVideoOtherAdUnitProcessed;
@end

@interface FSSRewardedVideoAdMobManager : NSObject <GADRewardBasedVideoAdDelegate>
+ (instancetype)sharedInstance;
- (void)loadWithApplicationID:(NSString *)applicationID
                     adUnitID:(NSString *)adUnitID
                     delegate:(id<FSSRewardedVideoAdMobManagerDelegate>)delegate;
- (void)presentFromViewController:(UIViewController *)viewController;
@end
NS_ASSUME_NONNULL_END
