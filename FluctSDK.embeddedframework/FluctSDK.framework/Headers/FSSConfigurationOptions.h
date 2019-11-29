//
//  FSSConfigurationOptions.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FSSDevelopmentEnvironmentType) {
    FSSDevelopmentEnvironmentTypeNative,
    FSSDevelopmentEnvironmentTypeUnity,
};

typedef NS_ENUM(NSUInteger, FSSMediationPlatformType) {
    FSSMediationPlatformTypeNone,
    FSSMediationPlatformTypeGoogleMobileAds,
    FSSMediationPlatformTypeMoPub
};

@interface FSSConfigurationOptions : NSObject
@property (nonatomic) FSSDevelopmentEnvironmentType envType;
@property (nonatomic, readonly) NSString *envName;
@property (nonatomic) NSString *envVersion;
@property (nonatomic) NSString *bridgePluginVersion;

@property (nonatomic) FSSMediationPlatformType mediationPlatformType;
@property (nonatomic, readonly, nullable) NSString *mediationPlatform;
@property (nonatomic) NSString *mediationPlatformSDKVersion;

+ (FSSConfigurationOptions *)defaultOptions;

NS_ASSUME_NONNULL_END

@end
