//
//  FluctCustomEventInfo.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_CLOSED_ENUM(NSUInteger, FluctAdUnitFormat) {
    FluctAdUnitFormatBanner,
    FluctAdUnitFormatMediumRectangle,
    FluctAdUnitFormatInterstitial,
    FluctAdUnitFormatRewardedVideo
};

@interface FluctCustomEventInfo : NSObject
@property (nonatomic, readonly) NSString *groupID;
@property (nonatomic, readonly) NSString *unitID;
@property (nonatomic, readonly) FluctAdUnitFormat adunitFormat;
@property (nonatomic, nullable, readonly) NSString *pricePoint;

+ (instancetype)customEventInfoFromMoPubInfo:(NSDictionary<NSString *, id> *_Nullable)info error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
