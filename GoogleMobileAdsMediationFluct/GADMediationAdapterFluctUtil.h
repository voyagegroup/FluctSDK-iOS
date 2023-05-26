//
//  GADMediationAdapterFluctUtil.h
//  GoogleMobileAdsMediationFluct
//
//  Copyright © 2023 fluct, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@import GoogleMobileAds;

@interface GADMediationAdapterFluctUtil : NSObject

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler;

+ (GADVersionNumber)adSDKVersion;

+ (GADVersionNumber)adapterVersion;
@end

NS_ASSUME_NONNULL_END
