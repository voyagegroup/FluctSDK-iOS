//
//  ALFluctMediationAdapterParam.h
//  MaxMediationAdapterFluct
//
//

#import <AppLovinSDK/AppLovinSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALFluctMediationAdapterParam : NSObject
- (instancetype)initWithParameters:(nonnull id<MAAdapterResponseParameters>)params;
@property (nonatomic, readonly, copy) NSString *groupId;
@property (nonatomic, readonly, copy) NSString *unitId;
@end

NS_ASSUME_NONNULL_END
