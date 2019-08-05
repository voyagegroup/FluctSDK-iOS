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
- (void)loadSuccess;
- (void)loadFailure:(AdColonyAdRequestError *)error;
- (void)open;
- (void)close;
- (void)rewarded;
- (void)click;
- (void)expired;
@end

@interface FSSRewardedVideoAdColonyManager : NSObject
+ (instancetype)sharedInstance;
- (void)configureWithAppId:(NSString *)appId
                   zoneIDs:(NSArray<NSString *> *)zoneIDs
                  testMode:(BOOL)testMode
                     debug:(BOOL)debugMode;
- (void)loadRewardedVideoWithZoneId:(NSString *)zoneId
                           delegate:(id<FSSRewardedVideoAdColonyManagerDelegate>)delegate;
- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController zoneID:(NSString *)zoneId;
@end
NS_ASSUME_NONNULL_END
