//
//  FluctVideoInterstitialCustomEvent.h
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

@interface FluctVideoInterstitialCustomEvent : MPFullscreenAdAdapter <MPThirdPartyFullscreenAdAdapter>
@end

NS_ASSUME_NONNULL_END
