//
//  FluctAdapterConfiguration.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDK/MoPub.h>)
#import <MoPubSDK/MoPub.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface FluctAdapterConfiguration : MPBaseAdapterConfiguration

@property (nonatomic, copy, readonly) NSString *adapterVersion;
@property (nonatomic, copy, readonly, nullable) NSString *biddingToken;
@property (nonatomic, copy, readonly) NSString *moPubNetworkName;
@property (nonatomic, copy, readonly) NSString *networkSdkVersion;

@end

NS_ASSUME_NONNULL_END
