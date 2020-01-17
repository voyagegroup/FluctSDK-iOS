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
    // targeting パラメータの設定は任意で、頂いたお問合わせの調査等で利用します。
    // 詳しくは
    // https://github.com/voyagegroup/FluctSDK-iOS/wiki/Objective-C%E3%81%A7%E3%81%AE%E5%8B%95%E7%94%BB%E3%83%AA%E3%83%AF%E3%83%BC%E3%83%89%E5%BA%83%E5%91%8A%E5%AE%9F%E8%A3%85
    // をご参照下さい
    FSSAdRequestTargeting *targeting = [FSSAdRequestTargeting new];
    // fluct_userという文字列を sha256 ハッシュ関数にかけた結果の e313cbbd0628f189fc60ced535b64c92726f3f8d1dd2e04aa20847ff332c8278 という文字列がfluctのサーバに送信されます
    targeting.userID = @"fluct_user";
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
