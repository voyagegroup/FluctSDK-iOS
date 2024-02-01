//
//  FSSRewardedVideoCustomEventAMoAd.m
//  FluctSDKApp
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

#if FSS_DEV_PROJ
#import <FluctSDKApp-Swift.h>
#else
#import <FluctSDK_MediationAdapter/FluctSDK_MediationAdapter-swift.h>
#endif

#import "FSSRewardedVideoCustomEventAMoAd.h"

typedef NS_ENUM(NSInteger, AMoAdErrorExtend) {
    AMoAdErrorExtendNotReady = -1,
    AMoAdErrorExtendAMoAdResult = -2,
    AMoAdErrorExtendPlayFailed = -3
};

@interface FSSRewardedVideoCustomEventAMoAd () <FSSAMoAdInterstitialVideoDelegate>
@property (nonnull) FSSAMoAdInterstitialVideo *rewardedVideo;
@end

@implementation FSSRewardedVideoCustomEventAMoAd

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                           setting:(id<FSSFullscreenVideoSetting>)setting {

    if (![FSSAMoAdInterstitialVideo isAMoAdActive]) {
        return nil;
    }

    FSSAMoAdInterstitialVideo *rewardedVideo = [[FSSAMoAdInterstitialVideo alloc] initWithSid:dictionary[@"sid"]];

    return [self initWithDictionary:dictionary
                           delegate:delegate
                           testMode:testMode
                          debugMode:debugMode
                          skippable:skippable
                          targeting:targeting
                            setting:setting
                      rewardedVideo:rewardedVideo];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                           setting:(id<FSSFullscreenVideoSetting>)setting
                     rewardedVideo:(FSSAMoAdInterstitialVideo *)rewardedVideo {

    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:targeting
                             setting:setting];

    if (self) {
        _rewardedVideo = rewardedVideo;
        _rewardedVideo.delegate = self;
        _rewardedVideo.isCancellable = NO;
    }
    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    [self.rewardedVideo load];
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    if (!self.rewardedVideo.isLoaded) {
        self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:FSSVideoErrorNotReady
                                              userInfo:nil];
        NSError *amoAdError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:AMoAdErrorExtendNotReady
                                              userInfo:nil];
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                     fluctError:fluctError
                                                 adnetworkError:amoAdError];
        return;
    }
    [self.rewardedVideo show];
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
}

// AMoAd SDK not support api for get sdk version
- (NSString *)sdkVersion {
    return @"";
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

#pragma mark - AMoAdInterstitialVideoDelegate

- (void)amoadInterstitialVideoDidLoadAdWithAmoadInterstitialVideo:(FSSAMoAdInterstitialVideo *)amoadInterstitialVideo
                                                           result:(enum FSSAMoAdResult)result {
    __weak __typeof(self) weakSelf = self;
    switch (result) {
    case FSSAMoAdResultSuccess: {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        dispatch_async(FSSWorkQueue(), ^{
            [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:self];
        });
        break;
    }
    case FSSAMoAdResultFailure: {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:FSSVideoErrorLoadFailed
                                              userInfo:nil];
        NSError *amoAdError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:AMoAdErrorExtendAMoAdResult
                                              userInfo:@{NSLocalizedDescriptionKey : @"AMoAdResult:Failure"}];
        dispatch_async(FSSWorkQueue(), ^{
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:self fluctError:fluctError adnetworkError:amoAdError];
        });
        break;
    }
    case FSSAMoAdResultEmpty: {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:FSSVideoErrorLoadFailed
                                              userInfo:nil];
        NSError *amoAdError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:AMoAdErrorExtendAMoAdResult
                                              userInfo:@{NSLocalizedDescriptionKey : @"AMoAdResult:Empty"}];
        dispatch_async(FSSWorkQueue(), ^{
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:self fluctError:fluctError adnetworkError:amoAdError];
        });
        break;
    }
    default: {
        self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:FSSVideoErrorLoadFailed
                                              userInfo:nil];
        NSError *amoAdError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                  code:AMoAdErrorExtendAMoAdResult
                                              userInfo:nil];
        dispatch_async(FSSWorkQueue(), ^{
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:self fluctError:fluctError adnetworkError:amoAdError];
        });
        break;
    }
    }
}

- (void)amoadInterstitialVideoDidStartWithAmoadInterstitialVideo:(FSSAMoAdInterstitialVideo *)amoadInterstitialVideo {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:self];
    });
}

- (void)amoadInterstitialVideoDidCompleteWithAmoadInterstitialVideo:(FSSAMoAdInterstitialVideo *)amoadInterstitialVideo {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:self];
    });
}

- (void)amoadInterstitialVideoDidFailToPlayWithAmoadInterstitialVideo:(FSSAMoAdInterstitialVideo *)amoadInterstitialVideo {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    NSError *fluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                              code:FSSVideoErrorPlayFailed
                                          userInfo:nil];
    NSError *amoAdError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                              code:AMoAdErrorExtendPlayFailed
                                          userInfo:nil];
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:self fluctError:fluctError adnetworkError:amoAdError];
    });
}

- (void)amoadInterstitialVideoDidShowWithAmoadInterstitialVideo:(FSSAMoAdInterstitialVideo *)amoadInterstitialVideo {
    // DidStartの後に呼ばれる
    // do nothing
}

- (void)amoadInterstitialVideoWillDismissWithAmoadInterstitialVideo:(FSSAMoAdInterstitialVideo *)amoadInterstitialVideo {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:self];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:self];
    });
}

- (void)amoadInterstitialVideoDidClickAdWithAmoadInterstitialVideo:(FSSAMoAdInterstitialVideo *)amoadInterstitialVideo {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidClickForCustomEvent:self];
    });
}

@end
