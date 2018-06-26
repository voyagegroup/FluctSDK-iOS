//
//  FSSRewardedVideoAdColonyManager.m
//  FluctSDK
//
//  Copyright © 2018年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoAdColonyManager.h"

typedef NS_ENUM(NSUInteger, AdColonyManagerState) {
    Initial,
    Configuring,
    Configured
};

@interface FSSRewardedVideoAdColonyManager ()
@property (nonatomic) AdColonyManagerState state;
@property (nonatomic) NSMutableArray *configCompletionArray;
@property (nonatomic) NSMutableDictionary<NSString *, id<FSSRewardedVideoAdColonyManagerDelegate>> *delegateTable;
@property (nonatomic) NSMutableDictionary<NSString *, AdColonyInterstitial *> *adTable;
@end

/*
 * Not thread safe. All method should be called on UI thread.
 */
@implementation FSSRewardedVideoAdColonyManager
+ (instancetype)sharedInstance {
    static FSSRewardedVideoAdColonyManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FSSRewardedVideoAdColonyManager new];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _state = Initial;
        _configCompletionArray = [NSMutableArray new];
        _delegateTable = [NSMutableDictionary new];
        _adTable = [NSMutableDictionary new];
    }
    return self;
}

- (void)configureWithAppId:(NSString *)appId zoneIDs:(NSArray<NSString *> *)zoneIDs testMode:(BOOL)testMode debug:(BOOL)debugMode {
    if (self.state == Configuring || self.state == Configured) {
        //do nothing
        return;
    }
    self.state = Configuring;
    AdColonyAppOptions *options = [AdColonyAppOptions new];
    options.testMode = testMode;
    options.disableLogging = !debugMode;
    options.mediationNetwork = @"fluct";

    __weak __typeof(self) weakSelf = self;
    [AdColony configureWithAppID:appId
                         zoneIDs:zoneIDs
                         options:options
                      completion:^(NSArray<AdColonyZone *> *_Nonnull zones) {
                          weakSelf.state = Configured;
                          __weak __typeof(self) weakSelf = self;
                          dispatch_async(FSSRewardedVideoWorkQueue(), ^{
                              for (void (^callback)(void) in weakSelf.configCompletionArray) {
                                  callback();
                              }
                          });
                      }];
}

- (void)loadRewardedVideoWithZoneId:(NSString *)zoneId
                           delegate:(id<FSSRewardedVideoAdColonyManagerDelegate>)delegate {
    _delegateTable[zoneId] = delegate;
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(delegate) weakDelegate = delegate;

    void (^callback)(void) = ^{
        [AdColony requestInterstitialInZone:zoneId
            options:nil
            success:^(AdColonyInterstitial *_Nonnull ad) {
                weakSelf.adTable[zoneId] = ad;
                [weakDelegate loadSuccess];
                [ad setOpen:^{
                    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
                        [weakDelegate open];
                    });
                }];
                [ad setClose:^{
                    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
                        [weakDelegate close];
                        [weakSelf.delegateTable removeObjectForKey:zoneId];
                        [weakSelf.adTable removeObjectForKey:zoneId];
                    });
                }];
                [ad setClick:^{
                    dispatch_async(FSSRewardedVideoWorkQueue(), ^{
                        [weakDelegate click];
                    });
                }];
            }
            failure:^(AdColonyAdRequestError *_Nonnull error) {
                [weakDelegate loadFailure:error];
                [weakSelf.delegateTable removeObjectForKey:zoneId];
            }];
    };

    if (self.state == Configured) {
        callback();
        return;
    }

    [_configCompletionArray addObject:callback];
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController zoneID:(NSString *)zoneId {
    AdColonyInterstitial *ad = _adTable[zoneId];
    if (ad.expired) {
        [_delegateTable[zoneId] expired];
        [_adTable removeObjectForKey:zoneId];
        return;
    }
    [ad showWithPresentingViewController:viewController];
}
@end
