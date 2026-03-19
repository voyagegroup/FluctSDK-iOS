//
//  FSSNativeAd.h
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import "FSSMediaContent.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSSNativeAd : NSObject

@property (nonatomic, readonly, nonnull) FSSMediaContent *mediaContent;

@property (nonatomic, readonly, copy, nullable) NSString *headline;

@property (nonatomic, readonly, copy, nullable) NSString *advertiser;

@property (nonatomic, readonly, copy, nullable) NSString *callToAction;

@end

NS_ASSUME_NONNULL_END
