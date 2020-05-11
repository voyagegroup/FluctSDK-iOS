//
//  FSSInAppBiddingBannerResponseCache.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSSInAppBiddingBannerResponseCache : NSObject

@property (class, nonatomic, readonly) FSSInAppBiddingBannerResponseCache *sharedInstance NS_SWIFT_NAME(shared);

- (void)setResponse:(NSDictionary<NSString *, id> *)response forGroupId:(NSString *)groupId unitId:(NSString *)unitId;
- (NSDictionary<NSString *, id> *_Nullable)responseForGroupId:(NSString *)groupId unitId:(NSString *)unitId pricePoint:(NSString *)pricePoint;

@end

NS_ASSUME_NONNULL_END
