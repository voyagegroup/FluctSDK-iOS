//
//  MoPubVideoInterstitialViewController.m
//  SampleApp
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "MoPubVideoInterstitialViewController.h"
#import <MoPub/MoPub.h>

@interface MoPubVideoInterstitialViewController () <MPInterstitialAdControllerDelegate>
@property (nonatomic, weak) IBOutlet UIButton *showButton;
@property (nonatomic, nullable) MPInterstitialAdController *interstitial;
@end

// AdUnitIDを適切なものに変えてください
static NSString *const kAdUnitID = @"f9095a7d80e5405e84021cf54d5caf2a";

@implementation MoPubVideoInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTouchUpLoadAdWithButton:(UIButton *)button {
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:kAdUnitID];
    self.interstitial.delegate = self;
    [self.interstitial loadAd];
}

- (IBAction)didTouchUpShowAdWithButton:(UIButton *)button {
    if (self.interstitial.ready) {
        [self.interstitial showFromViewController:self];
    }
}

#pragma mark - MPInterstitialAdControllerDelegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = YES;
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial withError:(NSError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __FUNCTION__);
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __FUNCTION__);
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __FUNCTION__);
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __FUNCTION__);
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = NO;
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __FUNCTION__);
}

@end
