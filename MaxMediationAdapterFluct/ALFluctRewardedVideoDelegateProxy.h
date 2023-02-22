//
//  ALFluctRewardedVideoDelegateProxy.h
//  MaxMediationAdapterFluct
//
//

#import <Foundation/Foundation.h>
@import FluctSDK;

NS_ASSUME_NONNULL_BEGIN

@protocol ALFluctRewardedVideoDelegateProxyItem <NSObject>
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

@interface ALFluctRewardedVideoDelegateProxy : NSObject <FSSRewardedVideoDelegate>
@property (class, nonatomic, readonly) ALFluctRewardedVideoDelegateProxy *sharedInstance;
- (void)registerDelegate:(id<ALFluctRewardedVideoDelegateProxyItem>)delegate
                 groupId:(NSString *)groupId
                  unitId:(NSString *)unitId;
@end

NS_ASSUME_NONNULL_END
