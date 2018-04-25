//
//  FSSConfigurationOptions.h
//  FluctSDK
//
//  Created by 清 貴幸 on 2017/12/13.
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FSSDevelopmentEnvironmentType) {
    FSSDevelopmentEnvironmentTypeNative,
    FSSDevelopmentEnvironmentTypeUnity,
};

@interface FSSConfigurationOptions : NSObject
@property (nonatomic) FSSDevelopmentEnvironmentType envType;
@property (nonatomic, readonly) NSString *envName;
@property (nonatomic) NSString *envVersion;
@property (nonatomic) NSString *bridgePluginVersion;

+ (FSSConfigurationOptions *)defaultOptions;

NS_ASSUME_NONNULL_END

@end
