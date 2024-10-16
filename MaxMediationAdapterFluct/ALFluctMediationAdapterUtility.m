//
//  ALFluctMediationAdapterUtility.m
//  MaxMediationAdapterFluct
//
//

#import "ALFluctMediationAdapterUtility.h"

@implementation ALFluctMediationAdapterUtility
+ (BOOL)canDeliverAds:(nonnull id<MAAdapterResponseParameters>)parameters {
    // GDPR
    NSNumber *userConsent = parameters.userConsent;
    bool canDeliverAdsForUserConsent = userConsent == nil || [userConsent boolValue];
    if (!canDeliverAdsForUserConsent) {
        return false;
    }

    // CCPA
    NSNumber *doNotSell = parameters.doNotSell;
    bool canDeliverAdsForDoNotSell = doNotSell == nil || ![doNotSell boolValue];
    if (!canDeliverAdsForDoNotSell) {
        return false;
    }

    return true;
}
@end
