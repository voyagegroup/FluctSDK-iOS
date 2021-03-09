//
//  RewardedVideoViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2020年 fluct, Inc. All rights reserved.
//

#import "RewardedVideoViewController.h"
@import FluctSDK;

static NSString *const kRewardedVideoGroupID = @"1000083204";
static NSString *const kRewardedVideoUnitID = @"1000124351";

@interface RewardedVideoViewController () <FSSRewardedVideoDelegate>
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@end

@implementation RewardedVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初期化及びデリゲート設定
    FSSRewardedVideo.sharedInstance.delegate = self;
    FSSRewardedVideoSetting *setting = FSSRewardedVideoSetting.defaultSetting;
    setting.debugMode = YES;
    FSSRewardedVideo.sharedInstance.setting = setting;
}

- (IBAction)didTouchUpLoadAd:(id)sender {
    // 動画リワード広告の読み込み
    FSSAdRequestTargeting *targeting = [FSSAdRequestTargeting new];
    [FSSRewardedVideo.sharedInstance loadRewardedVideoWithGroupId:kRewardedVideoGroupID
                                                           unitId:kRewardedVideoUnitID
                                                        targeting:targeting];
}

- (IBAction)didTouchUpShowAd:(id)sender {
    // 動画リワード広告が表示可能か確認
    if ([FSSRewardedVideo.sharedInstance hasAdAvailableForGroupId:kRewardedVideoGroupID unitId:kRewardedVideoUnitID]) {
        // 動画リワード広告の表示
        [FSSRewardedVideo.sharedInstance presentRewardedVideoAdForGroupId:kRewardedVideoGroupID
                                                                   unitId:kRewardedVideoUnitID
                                                       fromViewController:self];
    }
}

#pragma mark FSSRewardedVideoDelegate

- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    NSLog(@"rewarded video ad did load");
    self.showButton.enabled = YES;
}

- (void)rewardedVideoShouldRewardForGroupID:(NSString *)groupId unitId:(NSString *)unitId {
    NSLog(@"should rewarded for app user");
    self.showButton.enabled = NO;
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    // refs: error code list are FSSVideoError.h
    NSLog(@"rewarded video ad load failed. Because %@", error);
}

- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    NSLog(@"rewarded video ad will appear");
}

- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    NSLog(@"rewarded video ad did appear");
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    NSLog(@"rewarded video ad will disappear");
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId unitId:(NSString *)unitId {
    NSLog(@"rewarded video ad did disappear");
}

- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId unitId:(NSString *)unitId error:(NSError *)error {
    // refs: error code list are FSSVideoError.h
    NSLog(@"rewarded video ad play failed. Because %@", error);
}

@end
