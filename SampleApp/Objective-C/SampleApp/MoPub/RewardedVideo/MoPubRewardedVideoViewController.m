//
//  MoPubRewardedVideoViewController.m
//  SampleApp
//
//  Copyright © 2020 fluct, inc. All rights reserved.
//

#import "MoPubRewardedVideoViewController.h"
#import <FluctSDK/FluctSDK.h>
#import <MoPubMediationAdapterFluct/FluctInstanceMediationSettings.h>
#import <MoPubSDK/MoPub.h>

@interface MoPubRewardedVideoViewController () <MPRewardedAdsDelegate>
@property (nonatomic, weak) IBOutlet UIButton *showButton;
@end

// AdUnitIDを適切なものに変えてください
static NSString *const kAdUnitID = @"8d14fd46f8a449f8a5f1de814e4f5fde";

@implementation MoPubRewardedVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MPRewardedAds setDelegate:self forAdUnitId:kAdUnitID];
}

- (IBAction)didTouchUpLoadAdWithButton:(UIButton *)button {
    FSSRewardedVideoSetting *setting = [FSSRewardedVideoSetting defaultSetting];
    setting.debugMode = YES;
    setting.activation.unityAdsActivated = NO;

    FluctInstanceMediationSettings *mediationSetting = [FluctInstanceMediationSettings new];
    mediationSetting.setting = setting;
    [MPRewardedAds loadRewardedAdWithAdUnitID:kAdUnitID withMediationSettings:@[ mediationSetting ]];
}

- (IBAction)didTouchUpShowAdWithButton:(UIButton *)button {
    if ([MPRewardedAds hasAdAvailableForAdUnitID:kAdUnitID]) {
        MPReward *reward = [MPRewardedAds selectedRewardForAdUnitID:kAdUnitID];
        [MPRewardedAds presentRewardedAdForAdUnitID:kAdUnitID fromViewController:self withReward:reward];
    }
}

#pragma mark - MPRewardedAdsDelegate

- (void)rewardedAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = YES;
}

- (void)rewardedAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
}

- (void)rewardedAdWillPresentForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedAdDidPresentForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedAdDidFailToShowForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"%s, %@", __FUNCTION__, error);
}

- (void)rewardedAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPReward *)reward {
    NSLog(@"%s, %@", __FUNCTION__, reward);
}

- (void)rewardedAdDidExpireForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedAdWillDismissForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
}

- (void)rewardedAdDidDismissForAdUnitID:(NSString *)adUnitID {
    NSLog(@"%s", __FUNCTION__);
    self.showButton.enabled = NO;
}

@end
