//
//  FSSFullscreenVideoSetting.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FSSFullscreenVideoAdnetworkActivation.h"

@protocol FSSFullscreenVideoSetting <NSObject>
- (BOOL)isDebugMode;
- (BOOL)isTestMode;
- (id<FSSFullscreenVideoAdnetworkActivation>)activation;
- (NSDictionary<NSString *, id> *)dictionary;
@end
