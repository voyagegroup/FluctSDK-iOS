//
//  FSSAppLovin.m
//  FluctSDKApp
//
//  Copyright © 2024 fluct, Inc. All rights reserved.
//

#import "FSSAppLovin.h"

@interface FSSAppLovin () <FSSAppLovinProtocol>

@property (nonatomic) ALIncentivizedInterstitialAd *rewardedVideo;

@end

@implementation FSSAppLovin
- (void)initializeWithSdkKey:(NSString *)sdkKey
           completionHandler:(void (^)(BOOL))completion {
    [ALSdk shared].settings.creativeDebuggerEnabled = NO;
    ALSdkInitializationConfiguration *initConfig = [ALSdkInitializationConfiguration configurationWithSdkKey:sdkKey
                                                                                                builderBlock:^(ALSdkInitializationConfigurationBuilder *builder) {
                                                                                                    builder.mediationProvider = @"fluct";
                                                                                                }];
    [[ALSdk shared] initializeWithConfiguration:initConfig
                              completionHandler:^(ALSdkConfiguration *sdkConfig) {
                                  completion([[ALSdk shared] isInitialized]);
                              }];
}
- (void)load:(NSString *)zoneName
    loadDelegate:(nullable id<ALAdLoadDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate>)loadDelegate {
    self.rewardedVideo = [[ALIncentivizedInterstitialAd alloc] initWithZoneIdentifier:zoneName];
    self.rewardedVideo.adDisplayDelegate = loadDelegate;
    self.rewardedVideo.adVideoPlaybackDelegate = loadDelegate;
    [self.rewardedVideo preloadAndNotify:loadDelegate];
}

- (void)show {
    [self.rewardedVideo showAndNotify:nil];
}

- (BOOL)isReadyForDisplay {
    return [self.rewardedVideo isReadyForDisplay];
}

@end
