//
//  MoPubAdapterFluctError.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#ifndef FluctAdapterError_h
#define FluctAdapterError_h

static NSString *const MoPubAdapterFluctErrorDomain = @"jp.fluct.FluctSDK.MoPubCustomEvent";

typedef NS_ENUM(NSInteger, MoPubAdapterFluctError) {
    MoPubAdapterFluctErrorInvalidCustomParameters,
    MoPubAdapterFluctErrorInvalidAdSize,
    MoPubAdapterFluctErrorNotSupportAdunitFormat
};

#endif /* FluctAdapterError_h */
