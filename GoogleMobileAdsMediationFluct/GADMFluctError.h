//
//  GADMFluctError.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#ifndef GADMFluctError_h
#define GADMFluctError_h

static NSString *const GADMFluctErrorDomain = @"jp.fluct.GADMediationAdapterFluct";

typedef NS_ENUM(NSInteger, GADMFluctError) {
    GADMFluctErrorInvalidCustomParameters = 0,
    GADMFluctErrorInvalidSize = 1,
    GADMFluctErrorNoResponse = 2
};

#endif /* GADMFluctError_h */
