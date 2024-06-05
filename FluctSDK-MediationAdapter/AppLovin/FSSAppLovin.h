//
//  FSSAppLovin.h
//  FluctSDKApp
//
//  Copyright © 2024 fluct, Inc. All rights reserved.
//

#import <AppLovinSDK/AppLovinSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FSSAppLovinProtocol
- (void)initializeWithSdkKey:(NSString *)sdkKey
           completionHandler:(void (^)(BOOL))completion;
- (void)load:(NSString *)zoneName
    loadDelegate:(nullable id<ALAdLoadDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate>)loadDelegate;
- (void)show;
- (BOOL)isReadyForDisplay;

@end

@interface FSSAppLovin : NSObject <FSSAppLovinProtocol>
- (void)initializeWithSdkKey:(NSString *)sdkKey
           completionHandler:(void (^)(BOOL))completion;
- (void)load:(NSString *)zoneName
    loadDelegate:(nullable id<ALAdLoadDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate>)loadDelegate;
- (void)show;
- (BOOL)isReadyForDisplay;

@end

NS_ASSUME_NONNULL_END
