//
//  ALFluctMediationAdapterParam.m
//  MaxMediationAdapterFluct
//
//

#import "ALFluctMediationAdapterParam.h"

static NSString *const kGroupId = @"groupID";
static NSString *const kUnitId = @"unitID";

@implementation ALFluctMediationAdapterParam
- (instancetype)initWithParameters:(nonnull id<MAAdapterResponseParameters>)parameters {
    self = [super init];
    if (self) {
        if ([parameters.customParameters objectForKey:kGroupId] && [parameters.customParameters objectForKey:kUnitId]) {
            _groupId = parameters.customParameters[kGroupId];
            _unitId = parameters.customParameters[kUnitId];
        }
        NSString *placementIdentifier = parameters.thirdPartyAdPlacementIdentifier;
        NSArray<NSString *> *ids = [placementIdentifier componentsSeparatedByString:@","];
        if (ids.count == 2) {
            _groupId = ids[0];
            _unitId = ids[1];
        }
        if ([_groupId length] == 0 || [_unitId length] == 0) {
            return nil;
        }
    }
    return self;
}
@end
