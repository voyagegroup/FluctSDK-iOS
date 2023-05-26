//
//  GADAdapterFluctVideoDelegateProxy.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "GADAdapterFluctVideoDelegateProxy.h"

@interface GADAdapterFluctVideoDelegateProxy ()

@property (nonatomic) NSMutableDictionary<NSString *, id<GADAdapterFluctVideoDelegateProxyItem>> *delegateTable;

@end

@implementation GADAdapterFluctVideoDelegateProxy

+ (instancetype)sharedInstance {
    static GADAdapterFluctVideoDelegateProxy *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegateTable = [NSMutableDictionary new];
    }
    return self;
}

- (void)registerDelegate:(id<GADAdapterFluctVideoDelegateProxyItem>)delegate groupId:(NSString *)groupId unitId:(NSString *)unitId {
    NSString *key = [self keyWithGroupId:groupId unitId:unitId];
    self.delegateTable[key] = delegate;
}

- (NSString *)keyWithGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    return [NSString stringWithFormat:@"%@-%@", groupId, unitId];
}

#pragma mark - FSSRewardedVideoDelegate
- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    NSString *key = [self keyWithGroupId:groupId unitId:unitId];
    [self.delegateTable[key] rewardedVideoDidLoadForGroupID:groupId unitId:unitId];
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    NSString *key = [self keyWithGroupId:groupId unitId:unitId];
    [self.delegateTable[key] rewardedVideoDidFailToLoadForGroupId:groupId unitId:unitId error:error];
    self.delegateTable[key] = nil;
}

- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    NSString *key = [self keyWithGroupId:groupId unitId:unitId];
    [self.delegateTable[key] rewardedVideoWillAppearForGroupId:groupId unitId:unitId];
}

- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    NSString *key = [self keyWithGroupId:groupId unitId:unitId];
    [self.delegateTable[key] rewardedVideoDidAppearForGroupId:groupId unitId:unitId];
}

- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    NSString *key = [self keyWithGroupId:groupId unitId:unitId];
    [self.delegateTable[key] rewardedVideoDidFailToPlayForGroupId:groupId unitId:unitId error:error];
    self.delegateTable[key] = nil;
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    NSString *key = [self keyWithGroupId:groupId unitId:unitId];
    [self.delegateTable[key] rewardedVideoWillDisappearForGroupId:groupId unitId:unitId];
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    NSString *key = [self keyWithGroupId:groupId unitId:unitId];
    [self.delegateTable[key] rewardedVideoDidDisappearForGroupId:groupId unitId:unitId];
    self.delegateTable[key] = nil;
}

- (void)rewardedVideoShouldRewardForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    NSString *key = [self keyWithGroupId:groupId unitId:unitId];
    id<GADAdapterFluctVideoDelegateProxyItem> delegate = self.delegateTable[key];
    if ([delegate respondsToSelector:@selector(rewardedVideoShouldRewardForGroupID:unitId:)]) {
        [delegate rewardedVideoShouldRewardForGroupID:groupId unitId:unitId];
    }
}

- (void)rewardedVideoDidClickForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    NSString *key = [self keyWithGroupId:groupId unitId:unitId];
    id<GADAdapterFluctVideoDelegateProxyItem> delegate = self.delegateTable[key];
    if ([delegate respondsToSelector:@selector(rewardedVideoDidClickForGroupId:unitId:)]) {
        [delegate rewardedVideoDidClickForGroupId:groupId unitId:unitId];
    }
}

@end
