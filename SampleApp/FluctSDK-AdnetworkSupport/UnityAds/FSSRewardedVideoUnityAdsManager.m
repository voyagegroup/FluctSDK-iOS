//
//  FSSRewardedVideoUnityAdsManager.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoUnityAdsManager.h"

static FSSRewardedVideoUnityAdsManager *sharedInstance;

@interface FSSRewardedVideoUnityAdsManager () <UnityAdsExtendedDelegate>
@property (nonatomic) NSMutableDictionary *delegateTable;
@property (nonatomic, copy) NSString *currentPlacementId;
@end

@implementation FSSRewardedVideoUnityAdsManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FSSRewardedVideoUnityAdsManager alloc] init];
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
                               delegate:(id<FSSRewardedVideoUnityAdsManagerDelegate>)delegate
                               testMode:(BOOL)testMode
                              debugMode:(BOOL)debugMode {

    NSString *placementId = dictionary[@"placement_id"];
    self.delegateTable[placementId] = delegate;

    if (![UnityAds isInitialized]) {
        [UnityAds setDebugMode:debugMode];
        UADSMediationMetaData *mediationMetaData = [[UADSMediationMetaData alloc] init];
        [mediationMetaData setName:@"fluct"];
        [mediationMetaData setVersion:[FluctSDK version]];
        [mediationMetaData commit];
        [UnityAds initialize:dictionary[@"game_id"] delegate:self testMode:testMode];
    } else if ([UnityAds isReady:placementId]) {
        [delegate unityAdsReady:placementId];
    } else {
        [delegate unityAdsDidError:(UnityAdsError)UnityAdsErrorExtendLoadFailed
                       withMessage:@"Not Loaded"];
        [self.delegateTable removeObjectForKey:placementId];
    }
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController
                                     placementId:(nonnull NSString *)placementId {
    id<FSSRewardedVideoUnityAdsManagerDelegate> delegate = [self getDelegate:placementId];
    if ([UnityAds isReady:placementId]) {
        [delegate unityAdsWillAppear];
        self.currentPlacementId = placementId;
        [UnityAds show:viewController placementId:placementId];
    } else {
        [delegate unityAdsDidError:kUnityAdsErrorShowError withMessage:@"show error"];
        [self.delegateTable removeObjectForKey:placementId];
    }
}

- (id<FSSRewardedVideoUnityAdsManagerDelegate>)getDelegate:(NSString *)placementId {
    return self.delegateTable[placementId];
}

#pragma mark UnityAdsExtendedDelegate
- (void)unityAdsDidError:(UnityAdsError)error withMessage:(nonnull NSString *)message {
    if (error == kUnityAdsErrorShowError) {
        [[self getDelegate:self.currentPlacementId] unityAdsDidError:kUnityAdsErrorShowError withMessage:message];
        [self.delegateTable removeObjectForKey:self.currentPlacementId];
        return;
    }

    //notify to all delegates.
    [self.delegateTable enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id<FSSRewardedVideoUnityAdsManagerDelegate> _Nonnull delegate, BOOL *_Nonnull stop) {
        [delegate unityAdsDidError:error withMessage:message];
        [self.delegateTable removeObjectForKey:key];
    }];
}

- (void)unityAdsDidFinish:(nonnull NSString *)placementId withFinishState:(UnityAdsFinishState)state {
    [[self getDelegate:placementId] unityAdsDidFinish:placementId withFinishState:state];
    [self.delegateTable removeObjectForKey:placementId];
}

- (void)unityAdsDidStart:(nonnull NSString *)placementId {
    [[self getDelegate:placementId] unityAdsDidStart:placementId];
}

- (void)unityAdsReady:(nonnull NSString *)placementId {
    [[self getDelegate:placementId] unityAdsReady:placementId];
}

- (void)unityAdsDidClick:(nonnull NSString *)placementId {
    [[self getDelegate:placementId] unityAdsDidClick:placementId];
}

- (void)unityAdsPlacementStateChanged:(nonnull NSString *)placementId oldState:(UnityAdsPlacementState)oldState newState:(UnityAdsPlacementState)newState {
}
@end
