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
- (BOOL)isInformationIconActivated;
- (id<FSSFullscreenVideoAdnetworkActivation>)activation;
- (NSDictionary<NSString *, id> *)dictionary;
@end
