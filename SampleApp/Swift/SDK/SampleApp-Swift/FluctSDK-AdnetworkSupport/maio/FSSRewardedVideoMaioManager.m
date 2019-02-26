//
//  FSSRewardedVideoMaioManager.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoMaioManager.h"

@interface FSSRewardedVideoMaioManager ()
@property (nonatomic) NSMutableDictionary *delegateTable;
@property (nonatomic) MaioInstance *maioInstance;
@end

@implementation FSSRewardedVideoMaioManager

+ (instancetype)sharedInstance {
    static FSSRewardedVideoMaioManager *sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
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

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary
                               delegate:(id<FSSRewardedVideoMaioManagerDelegate>)delegate
                               testMode:(BOOL)testMode {

    NSString *zoneId = dictionary[@"zone_id"];
    self.delegateTable[zoneId] = delegate;

    if (!self.maioInstance) {
        self.maioInstance = [Maio startWithNonDefaultMediaId:dictionary[@"media_id"] delegate:self];
        [self.maioInstance setAdTestMode:testMode];
        return;
    }

    if ([self.maioInstance canShowAtZoneId:zoneId]) {
        [delegate maioDidChangeCanShow:zoneId newValue:YES];
    } else {
        [delegate maioDidFail:zoneId reason:(MaioFailReason)MaioFailReasonExtendLoadFailed];
        [self.delegateTable removeObjectForKey:zoneId];
    }
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController
                                          zoneId:(NSString *)zoneId {
    id<FSSRewardedVideoMaioManagerDelegate> delegate = [self getDelegate:zoneId];
    if ([self.maioInstance canShowAtZoneId:zoneId]) {
        [self.maioInstance showAtZoneId:zoneId vc:viewController];
    } else {
        [delegate maioDidFail:zoneId reason:MaioFailReasonVideoPlayback];
        [self.delegateTable removeObjectForKey:zoneId];
    }
}

- (id<FSSRewardedVideoMaioManagerDelegate>)getDelegate:(NSString *)zoneId {
    return self.delegateTable[zoneId];
}

#pragma mark MaioDelegate
- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    [[self getDelegate:zoneId] maioDidChangeCanShow:zoneId newValue:newValue];
}

- (void)maioWillStartAd:(NSString *)zoneId {
    [[self getDelegate:zoneId] maioWillStartAd:zoneId];
}

- (void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam {
    [[self getDelegate:zoneId] maioDidFinishAd:zoneId
                                      playtime:playtime
                                       skipped:skipped
                                   rewardParam:rewardParam];
}

- (void)maioDidClickAd:(NSString *)zoneId {
    [[self getDelegate:zoneId] maioDidClickAd:zoneId];
}

- (void)maioDidCloseAd:(NSString *)zoneId {
    [[self getDelegate:zoneId] maioDidCloseAd:zoneId];
    [self.delegateTable removeObjectForKey:zoneId];
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    if (zoneId.length) {
        //error for specific zoneId
        [[self getDelegate:zoneId] maioDidFail:zoneId reason:reason];
        [self.delegateTable removeObjectForKey:zoneId];
        return;
    }

    //error for all zoneId
    [self.delegateTable enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id<FSSRewardedVideoMaioManagerDelegate> _Nonnull delegate, BOOL *_Nonnull stop) {
        [delegate maioDidFail:zoneId reason:reason];
        [self.delegateTable removeObjectForKey:key];
    }];
}
@end
