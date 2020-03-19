//
//  FluctRewardedVideoDelegateRouter.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <FluctSDK/FluctSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FluctRewardedVideoDelegateRouter : NSObject <FSSRewardedVideoDelegate, FSSRewardedVideoRTBDelegate>

+ (FluctRewardedVideoDelegateRouter *)sharedInstance;

- (void)addDelegate:(id<FSSRewardedVideoDelegate>)delegate groupID:(NSString *)groupID unitID:(NSString *)unitID;
- (void)addRTBDelegate:(id<FSSRewardedVideoRTBDelegate>)delegate groupID:(NSString *)groupID unitID:(NSString *)unitID;

@end

NS_ASSUME_NONNULL_END
