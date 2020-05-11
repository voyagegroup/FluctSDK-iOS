//
//  FSSRewardedVideoCustomEventStarter.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FSSInAppBiddingFullscreenVideoResponseCache.h"
#import "FSSRewardedVideo.h"
#import "FSSRewardedVideoRTBDelegate.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FSSRewardedVideoCustomEventStarter;

@protocol FSSRewardedVideoCustomEventStarterDelegate <NSObject>
- (void)customEventNotFoundResponse:(FSSRewardedVideoCustomEventStarter *)customEvent;
@end

@interface FSSRewardedVideoCustomEventStarter : NSObject

@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *unitId;

@property (nonatomic, weak, nullable) id<FSSRewardedVideoCustomEventStarterDelegate> delegate;

- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint;
- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint cache:(FSSInAppBiddingFullscreenVideoResponseCache *)cache;

- (void)requestWithSetting:(FSSRewardedVideoSetting *)setting delegate:(id<FSSRewardedVideoDelegate>)delegate rtbDelegate:(id<FSSRewardedVideoRTBDelegate>)rtbDelegate;
- (BOOL)hasAdAvailable;
- (void)presentAdFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
