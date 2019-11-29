//
//  FSSAdViewCustomEventDelegate.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FSSAdView.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FSSAdViewCustomEventDelegate <NSObject>
- (void)adViewDidReadyForCustomEvent:(FSSAdView *)adView;
@end

@interface FSSAdView ()
@property (nonatomic, nullable, weak) id<FSSAdViewCustomEventDelegate> customEventDelegate;
@end

NS_ASSUME_NONNULL_END
