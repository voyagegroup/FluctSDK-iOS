//
//  FSSRewardedVideo.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSSAdRequestTargeting.h"
#import "FSSRewardedVideoSetting.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FSSRewardedVideoDelegate <NSObject>

@optional
- (void)rewardedVideoShouldRewardForGroupID:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error;
- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error;

@end

@interface FSSRewardedVideo : NSObject

@property (class, nonatomic, readonly) FSSRewardedVideo *sharedInstance NS_SWIFT_NAME(shared);
@property (nonatomic, weak) id<FSSRewardedVideoDelegate> delegate;
@property (nonatomic) FSSRewardedVideoSetting *setting;

- (void)loadRewardedVideoWithGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)loadRewardedVideoWithGroupId:(NSString *)groupId unitId:(NSString *)unitId targeting:(nullable FSSAdRequestTargeting *)targeting;
- (BOOL)hasAdAvailableForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)presentRewardedVideoAdForGroupId:(NSString *)groupId unitId:(NSString *)unitId fromViewController:(UIViewController *)viewController;

- (void)loadRewardedVideoWithGroupId:(NSString *)groupId unitId:(NSString *)unitId info:(NSDictionary<NSString *, id> *)info requestedDate:(NSDate *)requestedDate;

@end

NS_ASSUME_NONNULL_END
