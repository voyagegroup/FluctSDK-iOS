//
//  FSSBannerCustomEventOptimizer.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FSSAdView.h"
#import "FSSInAppBiddingBannerResponseCache.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FSSBannerCustomEventOptimizer;

@protocol FSSBannerCustomEventOptimizerDelegate <NSObject>
- (void)customEventNotFoundResponse:(FSSBannerCustomEventOptimizer *)customEvent;
- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent didStoreAdView:(FSSAdView *)adView;
- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent didFailToStoreAdView:(FSSAdView *)adView withError:(NSError *)error;
- (void)customEvent:(FSSBannerCustomEventOptimizer *)customEvent willLeaveApplicationForAdView:(FSSAdView *)adView;
@end

@interface FSSBannerCustomEventOptimizer : NSObject

@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *unitId;
@property (nonatomic) NSString *pricePoint;

@property (nonatomic, weak, nullable) id<FSSBannerCustomEventOptimizerDelegate> delegate;

- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint;
- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint cache:(FSSInAppBiddingBannerResponseCache *)cache;

- (void)requestWithRootViewController:(UIViewController *)rootViewController size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
