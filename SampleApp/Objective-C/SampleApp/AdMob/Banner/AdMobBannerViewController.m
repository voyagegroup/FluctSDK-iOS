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

    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeBanner];
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

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
}

@end
