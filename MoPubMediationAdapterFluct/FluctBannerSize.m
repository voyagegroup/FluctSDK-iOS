//
//  FluctBannerSize.m
//  FluctSDK
//
//  Copyright © 2021 fluct, inc. All rights reserved.
//

#import "FluctBannerSize.h"

@interface FluctBannerSize ()
@end

@implementation FluctBannerSize

+ (FSSAdSize)getFluctAdSize:(CGSize)size {
    CGFloat height = size.height;
    CGFloat width = size.width;

    if (height >= FSSAdSize300x250.size.height && width >= FSSAdSize300x250.size.width) {
        return FSSAdSize300x250;
    }
    if (height >= FSSAdSize320x50.size.height && width >= FSSAdSize320x50.size.width) {
        return FSSAdSize320x50;
    }

    return (FSSAdSize){CGSizeZero};
}

@end
