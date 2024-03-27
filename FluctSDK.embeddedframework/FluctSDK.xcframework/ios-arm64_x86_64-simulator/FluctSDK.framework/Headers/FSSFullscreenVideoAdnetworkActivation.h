//
//  FSSFullscreenVideoAdnetworkActivation.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

@protocol FSSFullscreenVideoAdnetworkActivation <NSObject>

- (BOOL)isAMoAdActivated;
- (BOOL)isAppLovinActivated;
- (BOOL)isFiveActivated;
- (BOOL)isFluctActivated;
- (BOOL)isMaioActivated;
- (BOOL)isPangleActivated;
- (BOOL)isUnityAdsActivated;
- (BOOL)hasDeactivatedAdnetwork;

@end
