//
//  FSSRewardedVideoAdColonyManager.h
//  FluctSDK
//
//  Copyright © 2018年 fluct, Inc. All rights reserved.
//

#import <AdColony/AdColony.h>
#import <FluctSDK/FluctSDK.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FSSRewardedVideoAdColonyManagerDelegate <NSObject>
- (void)adColonyInterstitialDidLoad;
- (void)adColonyInterstitialDidFailToLoad:(AdColonyAdRequestError *)error;
- (void)adColonyInterstitialWillOpen;
- (void)adColonyInterstitialDidClose;
- (void)rewarded;
- (void)adColonyInterstitialDidReceiveClick;
- (void)adColonyInterstitialExpired;
@end

@interface FSSAdColonyDelegateDispacher : NSObject <AdColonyInterstitialDelegate>
@property (nonatomic, weak) id<FSSRewardedVideoAdColonyManagerDelegate> delegate;
@property (nonatomic, nullable) AdColonyInterstitial *ad;
@end

@interface FSSRewardedVideoAdColonyManager : NSObject
+ (instancetype)sharedInstance;
- (void)configureWithAppId:(NSString *)appId
                  testMode:(BOOL)testMode
                     debug:(BOOL)debugMode;
- (void)loadRewardedVideoWithZoneId:(NSString *)zoneId
                           delegate:(id<FSSRewardedVideoAdColonyManagerDelegate>)delegate;
- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController zoneID:(NSString *)zoneId;
@end
NS_ASSUME_NONNULL_END
