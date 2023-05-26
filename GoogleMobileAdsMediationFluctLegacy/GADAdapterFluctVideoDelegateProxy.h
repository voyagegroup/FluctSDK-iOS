//
//  GADAdapterFluctVideoDelegateProxy.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import FluctSDK;

NS_ASSUME_NONNULL_BEGIN
@protocol GADAdapterFluctVideoDelegateProxyItem <NSObject>
- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error;
- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error;
@optional
- (void)rewardedVideoShouldRewardForGroupID:(NSString *)groupId unitId:(NSString *)unitId;
- (void)rewardedVideoDidClickForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
@end

@interface GADAdapterFluctVideoDelegateProxy : NSObject <FSSRewardedVideoDelegate, FSSRewardedVideoRTBDelegate>

@property (class, nonatomic, readonly) GADAdapterFluctVideoDelegateProxy *sharedInstance;
- (void)registerDelegate:(id<GADAdapterFluctVideoDelegateProxyItem>)delegate groupId:(NSString *)groupId unitId:(NSString *)unitId;

@end

NS_ASSUME_NONNULL_END
