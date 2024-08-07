//
//  FSSMaio.m
//  FluctSDK
//
//  Copyright © 2024 fluct, Inc. All rights reserved.
//

#import "FSSMaio.h"

@interface FSSMaio () <FSSMaioProtocol, MaioRewardedLoadCallback>

@property (nonatomic) MaioRewarded *rewardedVideo;
@end

@implementation FSSMaio

- (void)load:(NSString *)zoneId
        testMode:(BOOL)testMode
    loadCallback:(nullable id<MaioRewardedLoadCallback>)loadCallback {
    MaioRequest *maioRequest = [[MaioRequest alloc] initWithZoneId:zoneId testMode:testMode];
    self.rewardedVideo = [MaioRewarded loadAdWithRequest:maioRequest callback:loadCallback];
}

- (void)show:(UIViewController *)viewController
    showCallback:(nullable id<MaioRewardedShowCallback>)showCallback {
    [self.rewardedVideo showWithViewContext:viewController callback:showCallback];
}

@end
