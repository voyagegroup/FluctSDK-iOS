//
//  FluctBannerSize.h
//  FluctSDK
//
//  Copyright © 2021 fluct, inc. All rights reserved.
//

#import <FluctSDK/FluctSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FluctBannerSize : NSObject
+ (FSSAdSize)getFluctAdSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
