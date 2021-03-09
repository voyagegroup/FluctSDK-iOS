//
//  AppDelegate.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2020 fluct, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <MoPubSDK/MoPub.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initializeAdMob];
    [self initializeMoPub];
    return YES;
}

- (void)initializeAdMob {
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
}

- (void)initializeMoPub {
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:@"49b7ea66f5124f47b0d89e85b40137bf"];
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:nil];
}

@end
