//
//  FSSRewardedVideoCustomEventMaio.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventMaio.h"

@interface FSSRewardedVideoCustomEventMaio ()

@property (nonatomic) id<FSSMaioProtocol> maio;
@property (nonatomic, copy) NSString *zoneID;
@end

static NSString *const FSSMaioSupportVersion = @"14.0";

@implementation FSSRewardedVideoCustomEventMaio

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                           setting:(id<FSSFullscreenVideoSetting>)setting {
    if (![FSSRewardedVideoCustomEventMaio isOSAtLeastVersion:FSSMaioSupportVersion]) {
        return nil;
    }
    return [self initWithDictionary:dictionary
                           delegate:delegate
                           testMode:testMode
                          debugMode:debugMode
                          skippable:skippable
                          targeting:nil
                            setting:setting
                               maio:[FSSMaio new]];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate
                          testMode:(BOOL)testMode
                         debugMode:(BOOL)debugMode
                         skippable:(BOOL)skippable
                         targeting:(FSSAdRequestTargeting *)targeting
                           setting:(id<FSSFullscreenVideoSetting>)setting
                              maio:(id<FSSMaioProtocol>)maio {
    self = [super initWithDictionary:dictionary
                            delegate:delegate
                            testMode:testMode
                           debugMode:debugMode
                           skippable:skippable
                           targeting:nil
                             setting:setting];

    if (!self) {
        return nil;
    }
    _zoneID = dictionary[@"zone_id"];
    _maio = maio;
    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    [self.maio load:self.zoneID testMode:self.testMode loadCallback:self];
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    [self.maio show:viewController showCallback:self];
}

- (NSString *)sdkVersion {
    return [[MaioVersion shared] toString];
}

#pragma mark MaioRewardedLoadCallback

- (void)didLoad:(MaioRewarded *_Nonnull)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
    });
}

- (void)didFail:(MaioRewarded *_Nonnull)ad errorCode:(NSInteger)errorCode {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        switch ([FSSRewardedVideoCustomEventMaio mapErrorCode:errorCode]) {
        case FSSVideoErrorLoadFailed:
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorLoadFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:errorCode
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"didFail load."}]];
            break;
        case FSSVideoErrorPlayFailed:
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
            [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:FSSVideoErrorPlayFailed
                                                                                        userInfo:nil]
                                                         adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                            code:errorCode
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"didFail show."}]];
            break;
        default:
            // https://github.com/imobile/MaioSDK-v2-iOS/wiki/API-Rererences#optional-func-didfail_-admaiorewarded-errorcode-int
            // maioSDKはロード失敗、再生失敗で呼ばれるデリゲートが同じため、adnwStatusでロード前: ロード失敗、ロード後: 再生失敗と分けています。ただし、defaultに入ってくるのはunknownエラーのみなので、分けておく大きな意味はありません。
            if (weakSelf.adnwStatus == FSSRewardedVideoADNWStatusLoaded) {
                weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
                [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                code:FSSVideoErrorUnknown
                                                                                            userInfo:nil]
                                                             adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                code:errorCode
                                                                                            userInfo:@{NSLocalizedDescriptionKey : @"didFail unknown."}]];
            } else {
                weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
                [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                                 fluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                code:FSSVideoErrorUnknown
                                                                                            userInfo:nil]
                                                             adnetworkError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                code:errorCode
                                                                                            userInfo:@{NSLocalizedDescriptionKey : @"didFail unknown."}]];
            }
            break;
        }
    });
}

+ (FSSVideoError)mapErrorCode:(NSInteger)maioErrorCode {
    // https://github.com/imobile/MaioSDK-v2-iOS/wiki/API-Rererences#errorcode
    NSString *numberString = [NSString stringWithFormat:@"%ld", (long)maioErrorCode];
    unichar firstCharacter = [numberString characterAtIndex:0];

    if (firstCharacter == '1') {
        return FSSVideoErrorLoadFailed;
    }

    if (firstCharacter == '2') {
        return FSSVideoErrorPlayFailed;
    }
    return FSSVideoErrorUnknown;
}

#pragma mark MaioRewardedShowCallback

- (void)didOpen:(MaioRewarded *_Nonnull)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)didClose:(MaioRewarded *_Nonnull)ad {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

- (void)didReward:(MaioRewarded *_Nonnull)ad reward:(RewardData *_Nonnull)reward {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
    });
}
@end
