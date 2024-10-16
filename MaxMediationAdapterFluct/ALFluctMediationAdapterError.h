//
//  ALFluctMediationAdapterError.h
//  MaxMediationAdapterFluct
//
//

#import <AppLovinSDK/AppLovinSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALFluctMediationAdapterError : NSObject

+ (MAAdapterError *)maxErrorFromFluctError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
