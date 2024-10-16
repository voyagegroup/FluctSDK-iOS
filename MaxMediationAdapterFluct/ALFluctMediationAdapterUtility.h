//
//  ALFluctMediationAdapterUtility.h
//  MaxMediationAdapterFluct
//
//

#import <AppLovinSDK/AppLovinSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALFluctMediationAdapterUtility : NSObject
+ (BOOL)canDeliverAds:(nonnull id<MAAdapterResponseParameters>)parameters;
@end

NS_ASSUME_NONNULL_END
