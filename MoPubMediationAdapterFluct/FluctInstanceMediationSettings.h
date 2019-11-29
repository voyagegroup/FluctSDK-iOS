//
//  FluctInstanceMediationSettings.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <FluctSDK/FluctSDK.h>
#import <Foundation/Foundation.h>
#import <MoPub/MoPub.h>

NS_ASSUME_NONNULL_BEGIN

@interface FluctInstanceMediationSettings : NSObject <MPMediationSettingsProtocol>
@property (nonatomic, nullable) FSSRewardedVideoSetting *setting;
@property (nonatomic, nullable) FSSAdRequestTargeting *targeting;
@end

NS_ASSUME_NONNULL_END
