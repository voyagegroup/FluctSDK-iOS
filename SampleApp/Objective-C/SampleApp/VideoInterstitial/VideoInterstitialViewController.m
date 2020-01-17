//
//  VideoInterstitialViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import "VideoInterstitialViewController.h"
@import FluctSDK;

static NSString *const kVideoInterstitialGroupID = @"1000104107";
static NSString *const kVideoInterstitialUnitID = @"1000160561";

@interface VideoInterstitialViewController () <FSSVideoInterstitialDelegate>
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (nonatomic) FSSVideoInterstitial *interstitial;
@end

@implementation VideoInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FSSVideoInterstitialSetting *settings = FSSVideoInterstitialSetting.defaultSetting;
    settings.debugMode = YES;
    self.interstitial = [[FSSVideoInterstitial alloc] initWithGroupId:kVideoInterstitialGroupID
                                                               unitId:kVideoInterstitialUnitID
                                                              setting:settings];
    self.interstitial.delegate = self;
}

- (IBAction)didTouchUpLoadAd:(id)sender {
    [self.interstitial loadAd];
}

- (IBAction)didTouchUpShowAd:(id)sender {
    if ([self.interstitial hasAdAvailable]) {
        [self.interstitial presentAdFromViewController:self];
    }
}

#pragma mark - FSSVideoInterstitialDelegate

- (void)videoInterstitialDidLoad:(FSSVideoInterstitial *)interstitial {
    NSLog(@"video interstitial ad did load");
    self.showButton.enabled = YES;
}

- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToLoadWithError:(NSError *)error {
    NSLog(@"video interstitial ad load failed. Because %@", error);
}

- (void)videoInterstitialWillAppear:(FSSVideoInterstitial *)interstitial {
    NSLog(@"video interstitial ad will appear");
}

- (void)videoInterstitialDidAppear:(FSSVideoInterstitial *)interstitial {
    NSLog(@"video interstitial ad did appear");
}

- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToPlayWithError:(NSError *)error {
    NSLog(@"video interstitial ad play failed. Because %@", error);
}

- (void)videoInterstitialWillDisappear:(FSSVideoInterstitial *)interstitial {
    NSLog(@"video interstitial ad will disappear");
    self.showButton.enabled = NO;
}

- (void)videoInterstitialDidDisappear:(FSSVideoInterstitial *)interstitial {
    NSLog(@"video interstitial ad did disappear");
}

@end
