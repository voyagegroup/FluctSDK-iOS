//
//  FSSVideoInterstitialRTBDelegate.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "FSSVideoInterstitial.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FSSVideoInterstitialRTBDelegate <NSObject>
- (void)videoInterstitialDidClick:(FSSVideoInterstitial *)interstitial;
@end

@interface FSSVideoInterstitial ()
@property (nonatomic, nullable, weak) id<FSSVideoInterstitialRTBDelegate> rtbDelegate;
@end

NS_ASSUME_NONNULL_END
