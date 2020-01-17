//
//  MoPubBannerViewController.m
//  SampleApp
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "MoPubBannerViewController.h"
#import <MoPub/MoPub.h>

@interface MoPubBannerViewController () <MPAdViewDelegate>
@property (nonatomic, nullable) MPAdView *adView;
@end

// AdUnitIDを適切なものに変えてください
static NSString *const kAdUnitID = @"49b7ea66f5124f47b0d89e85b40137bf";

@implementation MoPubBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.adView = [[MPAdView alloc] initWithAdUnitId:kAdUnitID];
    self.adView.delegate = self;
    self.adView.frame = CGRectMake(0, 0, 320, kMPPresetMaxAdSize50Height.height);
    [self.view addSubview:self.adView];
    [self.adView loadAdWithMaxAdSize:kMPPresetMaxAdSize50Height];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.adView.center = self.view.center;
}

#pragma mark - MPAdViewDelegate

- (UIViewController *)viewControllerForPresentingModalView {
    NSLog(@"%s", __FUNCTION__);
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize {
    NSLog(@"%s, %@", __FUNCTION__, NSStringFromCGSize(adSize));
}

- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
}

- (void)didDismissModalViewForAd:(MPAdView *)view {
    NSLog(@"%s", __FUNCTION__);
}

- (void)willPresentModalViewForAd:(MPAdView *)view {
    NSLog(@"%s", __FUNCTION__);
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view {
    NSLog(@"%s", __FUNCTION__);
}

@end
