//
//  FluctAdapterConfiguration.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FluctAdapterConfiguration.h"
#import <FluctSDK/FluctSDK.h>

static NSString *const kFluctNetworkName = @"fluct";

@implementation FluctAdapterConfiguration

- (NSString *)adapterVersion {
    return [FluctSDK version];
}

- (NSString *)biddingToken {
    return nil;
}

- (NSString *)moPubNetworkName {
    return kFluctNetworkName;
}

- (NSString *)networkSdkVersion {
    return [FluctSDK version];
}

- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> *)configuration complete:(void (^)(NSError *_Nullable))complete {
    if (complete) {
        complete(nil);
    }
}

@end
