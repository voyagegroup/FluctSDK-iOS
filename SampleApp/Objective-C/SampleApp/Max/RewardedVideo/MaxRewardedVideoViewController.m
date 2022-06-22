//
//  MaxRewardedVideoViewController.m
//  SampleApp
//
//  Copyright © 2022 fluct, inc. All rights reserved.
//

#import "MaxRewardedVideoViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import <FluctSDK/FluctSDK.h>

@interface MaxRewardedVideoViewController () <MARewardedAdDelegate>
@property (nonatomic, weak) IBOutlet UIButton *showButton;
@property (nonatomic, nullable) MARewardedAd *rewardedAd;
@end

// AdUnitIDを適切なものに変えてください
static NSString *const kAdUnitID = @"f681a5b35ac7822d";

@implementation MaxRewardedVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTouchUpLoadAdWithButton:(UIButton *)button {

    FSSRewardedVideoSetting *setting = FSSRewardedVideoSetting.defaultSetting;
    setting.debugMode = YES;
    setting.testMode = YES;

    [[FSSRewardedVideo sharedInstance] setSetting:setting];

    self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier:kAdUnitID];
    self.rewardedAd.delegate = self;

    [self.rewardedAd loadAd];

    self.showButton.enabled = NO;
}

- (IBAction)didTouchUpShowAdWithButton:(UIButton *)button {
    if (self.rewardedAd.isReady) {
        [self.rewardedAd showAd];
    }
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = YES;
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
    self.showButton.enabled = NO;
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@"%s", __FUNCTION__);
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"%s", __FUNCTION__);
}

- (void)didHideAd:(MAAd *)ad {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = NO;
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
    self.showButton.enabled = NO;
}

#pragma mark - MARewardedAdDelegate Protocol

- (void)didStartRewardedVideoForAd:(MAAd *)ad {
    NSLog(@"%s", __FUNCTION__);
}

- (void)didCompleteRewardedVideoForAd:(MAAd *)ad {
    NSLog(@"%s", __FUNCTION__);
}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward {
    NSLog(@"%s", __FUNCTION__);
}

@end
