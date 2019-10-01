//
//  GADAdapterFluctVideoDelegateProxy.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import FluctSDK;

NS_ASSUME_NONNULL_BEGIN

@interface GADAdapterFluctVideoDelegateProxy : NSObject <FSSRewardedVideoDelegate>

@property (class, nonatomic, readonly) GADAdapterFluctVideoDelegateProxy *sharedInstance;
- (void)registerDelegate:(id<FSSRewardedVideoDelegate>)delegate groupId:(NSString *)groupId unitId:(NSString *)unitId;

@end

NS_ASSUME_NONNULL_END
