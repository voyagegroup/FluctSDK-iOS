//
//  AdMobBannerViewController.m
//  SampleApp
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "AdMobBannerViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdMobBannerViewController () <GADBannerViewDelegate>
@property (nonatomic, nullable) GADBannerView *bannerView;
@end

// AdUnitIDを適切なものに変えてください
static NSString *const kAdUnitID = @"ca-app-pub-3010029359415397/1722697861";

@implementation AdMobBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView.rootViewController = self;
    bannerView.adUnitID = kAdUnitID;

    [self.view addSubview:bannerView];
    self.bannerView = bannerView;
    [bannerView loadRequest:[GADRequest request]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.bannerView.center = self.view.center;
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
}

@end
