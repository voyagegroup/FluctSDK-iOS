//
//  MoPubRewardedVideoViewController.m
//  SampleApp
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "MoPubRewardedVideoViewController.h"
#import <MoPub/MoPub.h>
#import <FluctSDK/FluctSDK.h>
#import <MoPubMediationAdapterFluct/FluctInstanceMediationSettings.h>

@interface MoPubRewardedVideoViewController () <MPRewardedVideoDelegate>
@property (nonatomic, weak) IBOutlet UIButton *showButton;
@end

// AdUnitIDを適切なものに変えてください
static NSString *const kAdUnitID = @"8d14fd46f8a449f8a5f1de814e4f5fde";

@implementation MoPubRewardedVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MPRewardedVideo setDelegate:self forAdUnitId:kAdUnitID];
}

- (IBAction)didTouchUpLoadAdWithButton:(UIButton *)button {
    FSSRewardedVideoSetting *setting = [FSSRewardedVideoSetting defaultSetting];
    setting.debugMode = YES;
    setting.activation.unityAdsActivated = NO;

    FluctInstanceMediationSettings *mediationSetting = [FluctInstanceMediationSettings new];
    mediationSetting.setting = setting;
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:kAdUnitID withMediationSettings:@[mediationSetting]];
}

- (IBAction)didTouchUpShowAdWithButton:(UIButton *)button {
    if ([MPRewardedVideo hasAdAvailableForAdUnitID:kAdUnitID]) {
        NSArray<MPRewardedVideoReward *> *rewards = [MPRewardedVideo availableRewardsForAdUnitID:kAdUnitID];
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:kAdUnitID fromViewController:self withReward:rewards.firstObject];
    }
}

#pragma mark - MPRewardedVideoDelegate

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = YES;
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    NSLog(@"%s, %@", __FUNCTION__, reward);
}

- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = NO;
}

@end
