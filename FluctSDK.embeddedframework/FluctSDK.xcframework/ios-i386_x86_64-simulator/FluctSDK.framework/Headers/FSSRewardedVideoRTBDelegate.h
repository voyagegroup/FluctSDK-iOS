//
//  FSSRewardedVideoRTBDelegate.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FSSRewardedVideoRTBDelegate <NSObject>
- (void)rewardedVideoDidClickForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
@end

@interface FSSRewardedVideo ()
@property (nonatomic, nullable, weak) id<FSSRewardedVideoRTBDelegate> rtbDelegate;
@end

NS_ASSUME_NONNULL_END
