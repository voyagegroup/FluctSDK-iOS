//
//  FSSNativeAdImage.h
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSSNativeAdImage : NSObject

@property (nonatomic, readonly, nullable) UIImage *image;

@property (nonatomic, readonly, copy, nullable) NSURL *imageURL;

@end

NS_ASSUME_NONNULL_END
