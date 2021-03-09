//
//  FSSVideoInterstitialCustomEventStarter.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FSSInAppBiddingFullscreenVideoResponseCache.h"
#import "FSSVideoInterstitial.h"
#import "FSSVideoInterstitialRTBDelegate.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FSSVideoInterstitialCustomEventStarter;

@protocol FSSVideoInterstitialCustomEventStarterDelegate <NSObject>
- (void)customEventNotFoundResponse:(FSSVideoInterstitialCustomEventStarter *)customEvent;
@end

@interface FSSVideoInterstitialCustomEventStarter : NSObject

@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *unitId;

@property (nonatomic, weak, nullable) id<FSSVideoInterstitialCustomEventStarterDelegate> delegate;

- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint;
- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint cache:(FSSInAppBiddingFullscreenVideoResponseCache *)cache;

- (void)requestWithSetting:(FSSVideoInterstitialSetting *)setting delegate:(id<FSSVideoInterstitialDelegate>)delegate rtbDelegate:(id<FSSVideoInterstitialRTBDelegate>)rtbDelegate;
- (BOOL)hasAdAvailable;
- (void)presentAdFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
