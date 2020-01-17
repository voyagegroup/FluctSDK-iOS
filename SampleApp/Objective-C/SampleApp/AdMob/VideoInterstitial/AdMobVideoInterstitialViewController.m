//
//  AdMobVideoInterstitialViewController.m
//  SampleApp
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "AdMobVideoInterstitialViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdMobVideoInterstitialViewController () <GADInterstitialDelegate>
@property (nonatomic, weak) IBOutlet UIButton *showButton;
@property (nonatomic, nullable) GADInterstitial *interstitial;
@end

// AdUnitIDを適切なものに変えてください
static NSString *const kAdUnitID = @"ca-app-pub-3010029359415397/5031866416";

@implementation AdMobVideoInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTouchUpLoadAdWithButton:(UIButton *)button {
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:kAdUnitID];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[GADRequest request]];
}

- (IBAction)didTouchUpShowAdWithButton:(UIButton *)button {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = YES;
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"%s", __FUNCTION__);
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"%s", __FUNCTION__);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = NO;
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"%s", __FUNCTION__);
}

- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    NSLog(@"%s", __FUNCTION__);
}

@end
