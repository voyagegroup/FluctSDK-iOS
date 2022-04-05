//
//  AppDelegate.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2020 fluct, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initializeAdMob];
    return YES;
}

- (void)initializeAdMob {
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
}

@end
