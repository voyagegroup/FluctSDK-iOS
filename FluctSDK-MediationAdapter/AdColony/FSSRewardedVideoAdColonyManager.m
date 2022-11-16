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

@implementation FSSAdColonyDelegateDispacher
- (instancetype)initWithDelegate:(id<FSSRewardedVideoAdColonyManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)adColonyInterstitialDidLoad:(AdColonyInterstitial *_Nonnull)interstitial {
    self.ad = interstitial;
    [self.delegate adColonyInterstitialDidLoad];
}

- (void)adColonyInterstitialDidFailToLoad:(AdColonyAdRequestError *_Nonnull)error {
    [self.delegate adColonyInterstitialDidFailToLoad:error];
}

- (void)adColonyInterstitialWillOpen:(AdColonyInterstitial *_Nonnull)interstitial {
    [self.delegate adColonyInterstitialWillOpen];
}

- (void)adColonyInterstitialDidClose:(AdColonyInterstitial *_Nonnull)interstitial {
    [self.delegate adColonyInterstitialDidClose];
}

- (void)adColonyInterstitialExpired:(AdColonyInterstitial *_Nonnull)interstitial {
    [self.delegate adColonyInterstitialExpired];
}

- (void)adColonyInterstitialWillLeaveApplication:(AdColonyInterstitial *_Nonnull)interstitial {
    // do nothing so far
}

- (void)adColonyInterstitialDidReceiveClick:(AdColonyInterstitial *_Nonnull)interstitial {
    [self.delegate adColonyInterstitialDidReceiveClick];
}
@end

@interface FSSRewardedVideoAdColonyManager ()
@property (nonatomic) AdColonyManagerState state;
@property (nonatomic) NSMutableArray *configCompletionArray;
@property (nonatomic) NSMutableDictionary<NSString *, FSSAdColonyDelegateDispacher *> *delegateDispatcherTable;
@end

/*
 * Not thread safe. All method should be called on UI thread.
 */
@implementation FSSRewardedVideoAdColonyManager

+ (instancetype)sharedInstance {
    static FSSRewardedVideoAdColonyManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _state = Initial;
        _configCompletionArray = [NSMutableArray new];
        _delegateDispatcherTable = [NSMutableDictionary new];
    }
    return self;
}

- (void)configureWithAppId:(NSString *)appId testMode:(BOOL)testMode debug:(BOOL)debugMode {
    if (self.state == Configuring || self.state == Configured) {
        // do nothing
        return;
    }
    self.state = Configuring;
    AdColonyAppOptions *options = [AdColonyAppOptions new];
    options.testMode = testMode;
    options.disableLogging = !debugMode;
    options.mediationNetwork = @"fluct";

    __weak __typeof(self) weakSelf = self;
    [AdColony configureWithAppID:appId
                         options:options
                      completion:^(NSArray<AdColonyZone *> *_Nonnull zones) {
                          [weakSelf adColonyConfigureCallback:zones];
                      }];
}

- (void)adColonyConfigureCallback:(NSArray<AdColonyZone *> *)zones {
    self.state = Configured;

    __weak __typeof(self) weakSelf = self;
    [zones enumerateObjectsUsingBlock:^(AdColonyZone *_Nonnull zone, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *zoneID = zone.identifier;
        zone.reward = ^(BOOL success, NSString *name, int amount) {
            FSSAdColonyDelegateDispacher *delegateDispatcher = weakSelf.delegateDispatcherTable[zoneID];
            __weak __typeof(delegateDispatcher) weakDelegateDispatcher = delegateDispatcher;
            dispatch_async(FSSWorkQueue(), ^{
                [weakDelegateDispatcher.delegate rewarded];
            });
        };
    }];
    dispatch_async(FSSWorkQueue(), ^{
        for (void (^callback)(void) in [weakSelf.configCompletionArray copy]) {
            callback();
            [weakSelf.configCompletionArray removeObject:callback];
        }
    });
}

- (void)loadRewardedVideoWithZoneId:(NSString *)zoneId
                           delegate:(id<FSSRewardedVideoAdColonyManagerDelegate>)delegate {

    FSSAdColonyDelegateDispacher *adcolonyDelegate = [self getOrCreateDelgateDispatcherByZoneId:zoneId
                                                                                           from:self.delegateDispatcherTable
                                                                                           with:delegate];
    __weak __typeof(adcolonyDelegate) weakDelegate = adcolonyDelegate;
    void (^callback)(void) = ^{
        [AdColony requestInterstitialInZone:zoneId options:nil andDelegate:weakDelegate];
    };

    if (self.state == Configured) {
        callback();
        return;
    }

    [_configCompletionArray addObject:callback];
}

- (FSSAdColonyDelegateDispacher *)getOrCreateDelgateDispatcherByZoneId:(NSString *)zoneId
                                                                  from:(NSMutableDictionary<NSString *, FSSAdColonyDelegateDispacher *> *)table
                                                                  with:(id<FSSRewardedVideoAdColonyManagerDelegate>)managerDelegate {
    if (!table[zoneId].delegate) {
        table[zoneId] = [[FSSAdColonyDelegateDispacher alloc] initWithDelegate:managerDelegate];
    }
    return table[zoneId];
}

- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController zoneID:(NSString *)zoneId {
    AdColonyInterstitial *ad = self.delegateDispatcherTable[zoneId].ad;
    if (ad.expired) {
        [self.delegateDispatcherTable[zoneId].delegate adColonyInterstitialExpired];
        [self.delegateDispatcherTable removeObjectForKey:zoneId];
        return;
    }
    [ad showWithPresentingViewController:viewController];
}
@end
