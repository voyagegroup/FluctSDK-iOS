//
//  ALFluctMediationAdapterError.h
//  MaxMediationAdapterFluct
//
//

#import <AppLovinSDK/AppLovinSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALFluctMediationAdapterError : NSObject

+ (MAAdapterError *)maxErrorFromFluctVideoError:(NSError *)error;
+ (MAAdapterError *)maxErrorFromFluctAdViewError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
