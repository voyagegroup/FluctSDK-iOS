//
//  FluctRewardedVideoDelegateRouter.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FluctRewardedVideoDelegateRouter.h"

@interface FluctRewardedVideoDelegateRouter ()
@property (nonatomic, nonnull) NSMapTable<NSString *, id<FSSRewardedVideoDelegate>> *delegateTable;
@property (nonatomic, nonnull) NSMapTable<NSString *, id<FSSRewardedVideoRTBDelegate>> *rtbDelegateTable;
@end

@implementation FluctRewardedVideoDelegateRouter

+ (FluctRewardedVideoDelegateRouter *)sharedInstance {
    static FluctRewardedVideoDelegateRouter *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegateTable = [NSMapTable strongToWeakObjectsMapTable];
        _rtbDelegateTable = [NSMapTable strongToWeakObjectsMapTable];
    }
    return self;
}

- (void)addDelegate:(id<FSSRewardedVideoDelegate>)delegate groupID:(NSString *)groupID unitID:(NSString *)unitID {
    NSString *key = [self keyWithGroupId:groupID unitId:unitID];
    [self.delegateTable setObject:delegate forKey:key];
}

- (void)addRTBDelegate:(id<FSSRewardedVideoRTBDelegate>)delegate groupID:(NSString *)groupID unitID:(NSString *)unitID {
    NSString *key = [self keyWithGroupId:groupID unitId:unitID];
    [self.rtbDelegateTable setObject:delegate forKey:key];
}

#pragma mark - FSSRewardedVideoDelegate

- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    id<FSSRewardedVideoDelegate> delegate = [self delegateFromGroupID:groupId unitID:unitId];
    if ([delegate respondsToSelector:@selector(rewardedVideoDidLoadForGroupID:unitId:)]) {
        [delegate rewardedVideoDidLoadForGroupID:groupId unitId:unitId];
    }
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    id<FSSRewardedVideoDelegate> delegate = [self delegateFromGroupID:groupId unitID:unitId];
    if ([delegate respondsToSelector:@selector(rewardedVideoDidFailToLoadForGroupId:unitId:error:)]) {
        [delegate rewardedVideoDidFailToLoadForGroupId:groupId unitId:unitId error:error];
    }
}

- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    id<FSSRewardedVideoDelegate> delegate = [self delegateFromGroupID:groupId unitID:unitId];
    if ([delegate respondsToSelector:@selector(rewardedVideoWillAppearForGroupId:unitId:)]) {
        [delegate rewardedVideoWillAppearForGroupId:groupId unitId:unitId];
    }
}

- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    id<FSSRewardedVideoDelegate> delegate = [self delegateFromGroupID:groupId unitID:unitId];
    if ([delegate respondsToSelector:@selector(rewardedVideoDidAppearForGroupId:unitId:)]) {
        [delegate rewardedVideoDidAppearForGroupId:groupId unitId:unitId];
    }
}

- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    id<FSSRewardedVideoDelegate> delegate = [self delegateFromGroupID:groupId unitID:unitId];
    if ([delegate respondsToSelector:@selector(rewardedVideoDidFailToPlayForGroupId:unitId:error:)]) {
        [delegate rewardedVideoDidFailToPlayForGroupId:groupId unitId:unitId error:error];
    }
}

- (void)rewardedVideoShouldRewardForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    id<FSSRewardedVideoDelegate> delegate = [self delegateFromGroupID:groupId unitID:unitId];
    if ([delegate respondsToSelector:@selector(rewardedVideoShouldRewardForGroupID:unitId:)]) {
        [delegate rewardedVideoShouldRewardForGroupID:groupId unitId:unitId];
    }
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    id<FSSRewardedVideoDelegate> delegate = [self delegateFromGroupID:groupId unitID:unitId];
    if ([delegate respondsToSelector:@selector(rewardedVideoWillDisappearForGroupId:unitId:)]) {
        [delegate rewardedVideoWillDisappearForGroupId:groupId unitId:unitId];
    }
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    id<FSSRewardedVideoDelegate> delegate = [self delegateFromGroupID:groupId unitID:unitId];
    if ([delegate respondsToSelector:@selector(rewardedVideoDidDisappearForGroupId:unitId:)]) {
        [delegate rewardedVideoDidDisappearForGroupId:groupId unitId:unitId];
    }
}

#pragma mark - FSSRewardedVideoRTBDelegate

- (void)rewardedVideoDidClickForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    id<FSSRewardedVideoRTBDelegate> delegate = [self rtbDelegateFromGroupID:groupId unitID:unitId];
    if ([delegate respondsToSelector:@selector(rewardedVideoDidClickForGroupId:unitId:)]) {
        [delegate rewardedVideoDidClickForGroupId:groupId unitId:unitId];
    }
}

#pragma mark - private

- (id<FSSRewardedVideoDelegate> _Nullable)delegateFromGroupID:(NSString *)groupID unitID:(NSString *)unitID {
    NSString *key = [self keyWithGroupId:groupID unitId:unitID];
    return [self.delegateTable objectForKey:key];
}

- (id<FSSRewardedVideoRTBDelegate> _Nullable)rtbDelegateFromGroupID:(NSString *)groupID unitID:(NSString *)unitID {
    NSString *key = [self keyWithGroupId:groupID unitId:unitID];
    return [self.rtbDelegateTable objectForKey:key];
}

- (NSString *)keyWithGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    return [NSString stringWithFormat:@"%@-%@", groupId, unitId];
}

@end
