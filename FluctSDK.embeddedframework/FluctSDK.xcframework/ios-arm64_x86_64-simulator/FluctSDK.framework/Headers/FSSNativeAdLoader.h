//
//  FSSNativeAdLoader.h
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FSSNativeAdLoader;
@class FSSNativeAd;

@protocol FSSNativeAdLoaderDelegate <NSObject>
@optional

- (void)nativeAdLoader:(nonnull FSSNativeAdLoader *)adLoader
    didFailToStoreAdWithError:(NSError *)error;

- (void)nativeAdLoader:(nonnull FSSNativeAdLoader *)adLoader didStoreNativeAd:(nonnull FSSNativeAd *)nativeAd;

@end

@interface FSSNativeAdLoader : NSObject

@property (nonatomic, weak, nullable) id<FSSNativeAdLoaderDelegate> delegate;
@property (nonatomic, readonly, nullable) FSSNativeAd *nativeAd;

- (instancetype)initWithGroupId:(NSString *)groupId
                         unitId:(NSString *)unitId;

- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
