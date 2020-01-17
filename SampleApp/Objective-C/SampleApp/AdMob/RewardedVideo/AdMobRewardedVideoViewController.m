//
//  AdMobRewardedVideoViewController.m
//  SampleApp
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "AdMobRewardedVideoViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <FluctSDK/FluctSDK.h>
#import <GoogleMobileAdsMediationFluct/GADMAdapterFluctExtras.h>

@interface AdMobRewardedVideoViewController () <GADRewardedAdDelegate>
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
    self.rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:kAdUnitID];

    FSSRewardedVideoSetting *setting = FSSRewardedVideoSetting.defaultSetting;
    setting.debugMode = YES;
    setting.activation.unityAdsActivated = NO;

    GADMAdapterFluctExtras *extras = [GADMAdapterFluctExtras new];
    extras.setting = setting;

    GADRequest *request = [GADRequest request];
    [request registerAdNetworkExtras:extras];

    [self.rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            NSLog(@"loadRequest:comptionHander error:   %@", error);
            return;
        }

        self.showButton.enabled = YES;
    }];
}

- (IBAction)didTouchUpShowAdWithButton:(UIButton *)button {
    if (self.rewardedAd.isReady) {
        [self.rewardedAd presentFromRootViewController:self delegate:self];
    }
}

#pragma mark - GADRewardedAdDelegate

- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
    NSLog(@"%s, %@", __FUNCTION__, reward);
}

- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
}

- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = NO;
}

- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
    NSLog(@"%s", __FUNCTION__);
}

@end
