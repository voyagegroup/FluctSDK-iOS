//
//  FSSInAppBiddingResponseCache.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FSSInAppBiddingCacheError) {
    FSSInAppBiddingCacheErrorNoContent = -1000,
    FSSInAppBiddingCacheErrorInvalidPricePoint = -1001,
    FSSInAppBiddingCacheErrorNotFoundPrice = -1002,
    FSSInAppBiddingCacheErrorBelowPricePoint = -1003
};

@interface FSSInAppBiddingResponseCache : NSObject

@property (class, nonatomic, readonly) FSSInAppBiddingResponseCache *sharedInstance NS_SWIFT_NAME(shared);

- (void)setResponse:(NSDictionary<NSString *, id> *)response forGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (void)clearResponseForGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (NSDictionary<NSString *, id> *_Nullable)responseForGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint;

@end

NS_ASSUME_NONNULL_END
