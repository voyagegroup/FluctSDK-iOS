//
//  ALFluctAdViewAdapter.h
//  MaxMediationAdapterFluct
//
//

#import "ALFluctMediationAdapter.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALFluctAdViewAdapter : NSObject
- (void)loadAdViewAdapterWithAdapter:(ALFluctMediationAdapter *)adapter
                          parameters:(id<MAAdapterResponseParameters>)parameters
                            adFormat:(MAAdFormat *)adFormat
                           andNotify:(id<MAAdViewAdapterDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
