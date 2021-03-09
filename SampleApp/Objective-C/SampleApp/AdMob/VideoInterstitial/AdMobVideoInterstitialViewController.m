//
//  AdMobVideoInterstitialViewController.m
//  SampleApp
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "AdMobVideoInterstitialViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdMobVideoInterstitialViewController () <GADFullScreenContentDelegate>
@property (nonatomic, weak) IBOutlet UIButton *showButton;
@property (nonatomic, nullable) GADInterstitialAd *interstitial;
@end

// AdUnitIDを適切なものに変えてください
static NSString *const kAdUnitID = @"ca-app-pub-3010029359415397/5031866416";

@implementation AdMobVideoInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTouchUpLoadAdWithButton:(UIButton *)button {
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:kAdUnitID
                                request:request
                      completionHandler:^(GADInterstitialAd *_Nullable interstitialAd, NSError *_Nullable error) {
                          if (error) {
                              NSLog(@"error:  %@", error);
                              return;
                          }
                          self.interstitial = interstitialAd;
                          self.interstitial.fullScreenContentDelegate = self;
                          self.showButton.enabled = YES;
                      }];
}

- (IBAction)didTouchUpShowAdWithButton:(UIButton *)button {
    [self.interstitial presentFromRootViewController:self];
}

#pragma mark - GADFullScreenContentDelegate

- (void)adDidPresentFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%s", __FUNCTION__);
}

- (void)adDidDismissFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = NO;
}

- (void)ad:(id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
    NSLog(@"%s: %@", __FUNCTION__, error);
}

@end
