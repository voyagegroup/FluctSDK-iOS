//
//  FSSRewardedVideoUnityAdsManager.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <FluctSDK/FluctSDK.h>
#import <UnityAds/UnityAds.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, UnityAdsErrorExtend) {
    UnityAdsErrorExtendLoadFailed = -1,
    UnityAdsErrorExtendTimeout = -2
};

@protocol FSSRewardedVideoUnityAdsManagerDelegate <NSObject>
- (void)unityAdsDidError:(UnityAdsError)error withMessage:(nonnull NSString *)message;
- (void)unityAdsDidFinish:(nonnull NSString *)placementId withFinishState:(UnityAdsFinishState)state;
- (void)unityAdsDidStart:(nonnull NSString *)placementId;
- (void)unityAdsReady:(nonnull NSString *)placementId;
- (void)unityAdsDidClick:(nonnull NSString *)placementId;
- (void)unityAdsWillAppear;
@end

@interface FSSRewardedVideoUnityAdsManager : NSObject
+ (instancetype)sharedInstance;
- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary
                               delegate:(id<FSSRewardedVideoUnityAdsManagerDelegate>)delegate
                               testMode:(BOOL)testMode
                              debugMode:(BOOL)debugMode;
- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController placementId:(NSString *)placementId;
@end

NS_ASSUME_NONNULL_END
