//
//  FSSVideoInterstitialCustomEventOptimizer.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FSSInAppBiddingFullscreenVideoResponseCache.h"
#import "FSSVideoInterstitial.h"
#import "FSSVideoInterstitialRTBDelegate.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FSSVideoInterstitialCustomEventOptimizer;

@protocol FSSVideoInterstitialCustomEventOptimizerDelegate <NSObject>
- (void)customEventNotFoundResponse:(FSSVideoInterstitialCustomEventOptimizer *)customEvent;
@end

@interface FSSVideoInterstitialCustomEventOptimizer : NSObject

@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *unitId;
@property (nonatomic) NSString *pricePoint;

@property (nonatomic, weak, nullable) id<FSSVideoInterstitialCustomEventOptimizerDelegate> delegate;

- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint;
- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint cache:(FSSInAppBiddingFullscreenVideoResponseCache *)cache;

- (void)requestWithSetting:(FSSVideoInterstitialSetting *)setting
                  delegate:(id<FSSVideoInterstitialDelegate>)delegate
               rtbDelegate:(id<FSSVideoInterstitialRTBDelegate>)rtbDelegate;

- (void)requestWithSetting:(FSSVideoInterstitialSetting *)setting
             requestedDate:(NSDate *_Nullable)requestedDate
                  delegate:(id<FSSVideoInterstitialDelegate>)delegate
               rtbDelegate:(id<FSSVideoInterstitialRTBDelegate>)rtbDelegate;

- (BOOL)hasAdAvailable;
- (void)presentAdFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
