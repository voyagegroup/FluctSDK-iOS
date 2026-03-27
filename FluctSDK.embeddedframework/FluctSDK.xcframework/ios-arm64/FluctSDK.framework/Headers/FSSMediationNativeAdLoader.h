//
//  FSSMediationNativeAdLoader.h
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FSSMediationNativeAdLoader;
@class FSSMediationNativeAd;

@protocol FSSMediationNativeAdLoaderDelegate <NSObject>
@optional

- (void)mediationNativeAdLoader:(nonnull FSSMediationNativeAdLoader *)adLoader
      didFailToStoreAdWithError:(NSError *)error;

- (void)mediationNativeAdLoader:(nonnull FSSMediationNativeAdLoader *)adLoader
      didStoreMediationNativeAd:(nonnull FSSMediationNativeAd *)nativeAd;

@end

@interface FSSMediationNativeAdLoader : NSObject

@property (nonatomic, weak, nullable) id<FSSMediationNativeAdLoaderDelegate> delegate;
@property (nonatomic, readonly, nullable) FSSMediationNativeAd *mediationNativeAd;

- (instancetype)initWithGroupId:(NSString *)groupId
                         unitId:(NSString *)unitId;

- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
