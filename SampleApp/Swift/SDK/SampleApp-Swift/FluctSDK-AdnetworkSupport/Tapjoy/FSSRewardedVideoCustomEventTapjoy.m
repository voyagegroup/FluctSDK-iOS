//
// FluctSDK
//
// Copyright (c) 2018 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoCustomEventTapjoy.h"
#import <Tapjoy/Tapjoy.h>

typedef NS_ENUM(NSInteger, FSSTapjoyConnectionStatus) {
    FSSTapjoyConnectionTrying,
    FSSTapjoyConnectionSucceeded,
    FSSTapjoyConnectionFailed
};

typedef NS_ENUM(NSInteger, TJErrorExtended) {
    TJErrorExtendedConnectionFailed = -1001,
    TJErrorExtendedPlayFailed = -1002,
    TJErrorExtendedNoContentAvailable = -1003,
};

@interface FSSRewardedVideoCustomEventTapjoy () <TJPlacementDelegate, TJPlacementVideoDelegate>
@property (nonatomic) TJPlacement *tjPlacement;
@property (nonatomic) FSSTapjoyConnectionStatus connectionStatus;
@end

@implementation FSSRewardedVideoCustomEventTapjoy

- (instancetype)initWithDictionary:(NSDictionary *)dictionary delegate:(id<FSSRewardedVideoCustomEventDelegate>)delegate testMode:(BOOL)testMode debugMode:(BOOL)debugMode targeting:(FSSAdRequestTargeting *)targeting {
    self = [super initWithDictionary:dictionary delegate:delegate testMode:testMode debugMode:debugMode targeting:nil];

    if (!self) {
        return nil;
    }

    if (![Tapjoy isLimitedConnected]) {
        if (debugMode) {
            [Tapjoy setDebugEnabled:debugMode];
        }

        _connectionStatus = FSSTapjoyConnectionTrying;

        // https://dev.tapjoy.com/ja/sdk-integration/ios/getting-started-guide-publishers-ios/#connect
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tjcConnectSuccess:)
                                                     name:TJC_LIMITED_CONNECT_SUCCESS
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tjcConnectFailed:)
                                                     name:TJC_LIMITED_CONNECT_FAILED
                                                   object:nil];

        [Tapjoy limitedConnect:dictionary[@"sdk_key"]];
    } else {
        _connectionStatus = FSSTapjoyConnectionSucceeded;
    }

    _tjPlacement = [TJPlacement limitedPlacementWithName:dictionary[@"placement_name"] mediationAgent:@"fluct" delegate:self];
    _tjPlacement.adapterVersion = [FluctSDK version];
    _tjPlacement.videoDelegate = self;

    return self;
}

- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary {
    if (_connectionStatus == FSSTapjoyConnectionTrying) {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
        return;
    }

    if (_connectionStatus == FSSTapjoyConnectionFailed) {
        [self onConnectionFailed];
        return;
    }

    if ([self.tjPlacement isContentReady]) {
        self.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
        [self.delegate rewardedVideoDidLoadForCustomEvent:self];
        return;
    }

    self.adnwStatus = FSSRewardedVideoADNWStatusLoading;
    [self.tjPlacement requestContent];
}

- (void)onConnectionFailed {
    self.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
    [self.delegate rewardedVideoDidFailToLoadForCustomEvent:self
                                                 fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                code:FSSRewardedVideoAdErrorLoadFailed
                                                                            userInfo:@{NSLocalizedDescriptionKey : @"Tapjoy connect Failed"}]
                                             adnetworkError:TJErrorExtendedConnectionFailed];
}

- (FSSRewardedVideoADNWStatus)loadStatus {
    return self.adnwStatus;
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController {
    [self.tjPlacement showContentWithViewController:viewController];
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
}

- (NSString *)sdkVersion {
    return [Tapjoy getVersion];
}

- (void)tjcConnectSuccess:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TJC_CONNECT_SUCCESS
                                                  object:nil];
    _connectionStatus = FSSTapjoyConnectionSucceeded;
    if (self.adnwStatus == FSSRewardedVideoADNWStatusLoading) {
        [self.tjPlacement requestContent];
    }
}

- (void)tjcConnectFailed:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TJC_CONNECT_FAILED
                                                  object:nil];

    _connectionStatus = FSSTapjoyConnectionFailed;

    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        if (weakSelf.adnwStatus == FSSRewardedVideoADNWStatusLoading) {
            [weakSelf onConnectionFailed];
        }
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TJC_CONNECT_SUCCESS
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TJC_CONNECT_FAILED
                                                  object:nil];
}

// https://ltv.tapjoy.com/sdk/api/objc/Protocols/TJPlacementDelegate.html
#pragma mark TJPlacementDelegate

- (void)requestDidSucceed:(TJPlacement *)placement {
    if (!placement.isContentAvailable) {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(FSSRewardedVideoWorkQueue(), ^{
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
            [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                             fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                            code:FSSRewardedVideoAdErrorLoadFailed
                                                                                        userInfo:@{NSLocalizedDescriptionKey : @"Tapjoy has no ad content"}]
                                                         adnetworkError:TJErrorExtendedNoContentAvailable];
        });
    }
}

- (void)contentIsReady:(TJPlacement *)placement {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        if (weakSelf.adnwStatus == FSSRewardedVideoADNWStatusLoading) {
            weakSelf.adnwStatus = FSSRewardedVideoADNWStatusLoaded;
            [weakSelf.delegate rewardedVideoDidLoadForCustomEvent:weakSelf];
        }
    });
}

- (void)requestDidFail:(TJPlacement *)placement error:(NSError *)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToLoadForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                        code:FSSRewardedVideoAdErrorLoadFailed
                                                                                    userInfo:error.userInfo]
                                                     adnetworkError:error.code];
    });
}

- (void)contentDidAppear:(TJPlacement *)placement {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
    });
}

- (void)contentDidDisappear:(TJPlacement *)placement {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
        [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
    });
}

#pragma mark TJVideoPlacementDelegate

- (void)videoDidStart:(TJPlacement *)placement {
}

- (void)videoDidComplete:(TJPlacement *)placement {
    __weak __typeof(self) weakSelf = self;

    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        [weakSelf.delegate rewardedVideoShouldRewardForCustomEvent:weakSelf];
    });
}

- (void)videoDidFail:(TJPlacement *)placement error:(NSString *)errorMsg {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
        weakSelf.adnwStatus = FSSRewardedVideoADNWStatusNotDisplayable;
        [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                         fluctError:[NSError errorWithDomain:FSSRewardedVideoAdsSDKDomain
                                                                                        code:FSSRewardedVideoAdErrorPlayFailed
                                                                                    userInfo:@{NSLocalizedDescriptionKey : errorMsg}]
                                                     adnetworkError:TJErrorExtendedPlayFailed];
    });
}

@end
