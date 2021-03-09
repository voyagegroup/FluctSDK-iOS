//
//  AdMobRewardedVideoViewController.m
//  SampleApp
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "AdMobRewardedVideoViewController.h"
#import <FluctSDK/FluctSDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <GoogleMobileAdsMediationFluct/GADMAdapterFluctExtras.h>

@interface AdMobRewardedVideoViewController () <GADFullScreenContentDelegate>
@property (nonatomic, weak) IBOutlet UIButton *showButton;
@property (nonatomic, nullable) GADRewardedAd *rewardedAd;
@end

// AdUnitIDを適切なものに変えてください
static NSString *const kAdUnitID = @"ca-app-pub-3010029359415397/4697035240";

@implementation AdMobRewardedVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTouchUpLoadAdWithButton:(UIButton *)button {
    GADRequest *request = [GADRequest request];

    FSSRewardedVideoSetting *setting = FSSRewardedVideoSetting.defaultSetting;
    setting.debugMode = YES;
    setting.activation.unityAdsActivated = NO;

    GADMAdapterFluctExtras *extras = [GADMAdapterFluctExtras new];
    extras.setting = setting;

    [request registerAdNetworkExtras:extras];

    [GADRewardedAd loadWithAdUnitID:kAdUnitID
                            request:request
                  completionHandler:^(GADRewardedAd *_Nullable rewardedAd, NSError *_Nullable error) {
                      if (error) {
                          NSLog(@"loadRequest:comptionHander error:   %@", error);
                          return;
                      }

                      self.rewardedAd = rewardedAd;
                      self.rewardedAd.fullScreenContentDelegate = self;
                      self.showButton.enabled = YES;
                  }];
}

- (IBAction)didTouchUpShowAdWithButton:(UIButton *)button {
    [self.rewardedAd presentFromRootViewController:self
                          userDidEarnRewardHandler:^{
                              NSLog(@"%s, %@", __FUNCTION__, self.rewardedAd.adReward);
                          }];
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
    NSLog(@"%s, %@", __FUNCTION__, error);
}

@end
