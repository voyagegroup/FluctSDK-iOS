//
//  FluctBannerCustomEventStarter.h
//  FluctSDK
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDK/MoPub.h>)
#import <MoPubSDK/MoPub.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface FluctBannerCustomEventStarter : MPInlineAdAdapter <MPThirdPartyInlineAdAdapter>
@end

NS_ASSUME_NONNULL_END
