//
//  FluctCustomEventInfo.m
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FluctCustomEventInfo.h"
#import "MoPubAdapterFluctError.h"

static NSString *const kCustomEventInfoAdunitFormatKey = @"adunit_format";
static NSString *const kCustomEventInfoGroupIDKey = @"groupID";
static NSString *const kCustomEventInfoUnitIDKey = @"unitID";
static NSString *const kMoPubAdunitFormatBanner = @"banner";
static NSString *const kMoPubAdunitFormatRectangle = @"medium_rectangle";
static NSString *const kMoPubAdunitFormatInterstitial = @"full";
static NSString *const kMoPubAdunitFormatRewardedVideo = @"rewarded_video";

@implementation FluctCustomEventInfo

+ (instancetype)customEventInfoFromMoPubInfo:(NSDictionary<NSString *, id> *)info error:(NSError *_Nullable __autoreleasing *)error {
    NSString *adunitFormat = info[kCustomEventInfoAdunitFormatKey];
    FluctAdUnitFormat fluctAdunitFormat;
    if ([adunitFormat isEqualToString:kMoPubAdunitFormatBanner]) {
        fluctAdunitFormat = FluctAdUnitFormatBanner;
    } else if ([adunitFormat isEqualToString:kMoPubAdunitFormatRectangle]) {
        fluctAdunitFormat = FluctAdUnitFormatMediumRectangle;
    } else if ([adunitFormat isEqualToString:kMoPubAdunitFormatInterstitial]) {
        fluctAdunitFormat = FluctAdUnitFormatInterstitial;
    } else if ([adunitFormat isEqualToString:kMoPubAdunitFormatRewardedVideo]) {
        fluctAdunitFormat = FluctAdUnitFormatRewardedVideo;
    } else {
        // fluctとして対応してないadunit formatが来た時はerror
        if (error) {
            *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                         code:MoPubAdapterFluctErrorNotSupportAdunitFormat
                                     userInfo:@{NSLocalizedDescriptionKey : @"not support adunit format"}];
        }
        return nil;
    }

    NSString *groupID = info[kCustomEventInfoGroupIDKey];
    NSString *unitID = info[kCustomEventInfoUnitIDKey];
    if (!(groupID && unitID)) {
        if (error) {
            *error = [NSError errorWithDomain:MoPubAdapterFluctErrorDomain
                                         code:MoPubAdapterFluctErrorInvalidCustomParameters
                                     userInfo:@{NSLocalizedDescriptionKey : @"invalid custom parameter"}];
        }
        return nil;
    }

    FluctCustomEventInfo *customEventInfo = [[FluctCustomEventInfo alloc] initWithGroupID:groupID
                                                                                   unitID:unitID
                                                                             adunitFormat:fluctAdunitFormat];
    return customEventInfo;
}

- (instancetype _Nonnull)initWithGroupID:(NSString *_Nonnull)groupID unitID:(NSString *_Nonnull)unitID adunitFormat:(FluctAdUnitFormat)adunitFormat {
    self = [super init];
    if (self) {
        _groupID = groupID;
        _unitID = unitID;
        _adunitFormat = adunitFormat;
    }
    return self;
}

@end
