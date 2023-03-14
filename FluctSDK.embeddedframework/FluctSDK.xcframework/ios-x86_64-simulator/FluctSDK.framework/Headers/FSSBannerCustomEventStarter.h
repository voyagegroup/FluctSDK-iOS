//
//  FSSBannerCustomEventStarter.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FSSAdView.h"
#import "FSSInAppBiddingBannerResponseCache.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FSSBannerCustomEventStarter;

@protocol FSSBannerCustomEventStarterDelegate <NSObject>
- (void)customEventNotFoundResponse:(FSSBannerCustomEventStarter *)customEvent;
- (void)customEvent:(FSSBannerCustomEventStarter *)customEvent didStoreAdView:(FSSAdView *)adView;
- (void)customEvent:(FSSBannerCustomEventStarter *)customEvent didFailToStoreAdView:(FSSAdView *)adView withError:(NSError *)error;
- (void)customEvent:(FSSBannerCustomEventStarter *)customEvent willLeaveApplicationForAdView:(FSSAdView *)adView;
@end

@interface FSSBannerCustomEventStarter : NSObject

@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *unitId;

@property (nonatomic, weak, nullable) id<FSSBannerCustomEventStarterDelegate> delegate;

- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint;
- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint cache:(FSSInAppBiddingBannerResponseCache *)cache;
- (void)requestWithAdSize:(CGSize)adSize rootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END
