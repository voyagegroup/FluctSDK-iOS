//
//  FSSMediationNativeAd.h
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import "FSSMediaContent.h"
#import "FSSNativeAdInformationIconView.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSSMediationNativeAd : NSObject

@property (nonatomic, readonly, nonnull) FSSMediaContent *mediaContent;
@property (nonatomic, readonly, copy, nullable) NSString *headline;
@property (nonatomic, readonly, copy, nullable) NSString *advertiser;
@property (nonatomic, readonly, copy, nullable) NSString *callToAction;
@property (nonatomic, readonly, nullable) FSSNativeAdInformationIconView *informationIconView;
- (void)trackImpression;
- (void)handleClickWithViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
