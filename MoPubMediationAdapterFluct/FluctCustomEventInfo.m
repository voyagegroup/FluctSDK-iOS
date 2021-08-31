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
static NSString *const kCustomEventInfoPricePointKey = @"pricePoint";

@implementation FluctCustomEventInfo

+ (instancetype)customEventInfoFromMoPubInfo:(NSDictionary<NSString *, id> *)info error:(NSError *_Nullable __autoreleasing *)error {
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

    NSString *pricePoint = info[kCustomEventInfoPricePointKey];

    FluctCustomEventInfo *customEventInfo = [[FluctCustomEventInfo alloc] initWithGroupID:groupID
                                                                                   unitID:unitID
                                                                               pricePoint:pricePoint];
    return customEventInfo;
}

- (instancetype _Nonnull)initWithGroupID:(NSString *_Nonnull)groupID
                                  unitID:(NSString *_Nonnull)unitID
                              pricePoint:(NSString *_Nullable)pricePoint {
    self = [super init];
    if (self) {
        _groupID = groupID;
        _unitID = unitID;
        _pricePoint = pricePoint;
    }
    return self;
}

@end
