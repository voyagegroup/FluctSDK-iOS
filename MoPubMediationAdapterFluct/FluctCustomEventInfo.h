//
//  FluctCustomEventInfo.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FluctCustomEventInfo : NSObject
@property (nonatomic, readonly) NSString *groupID;
@property (nonatomic, readonly) NSString *unitID;
@property (nonatomic, nullable, readonly) NSString *pricePoint;

+ (instancetype)customEventInfoFromMoPubInfo:(NSDictionary<NSString *, id> *_Nullable)info error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
