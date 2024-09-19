//
//  FluctNetworkMediationAdapter.m
//  MaxMediationAdapterFluct
//
//

#import "ALFluctMediationAdapter.h"
#import "ALFluctRewardedVideoDelegateProxy.h"
@import FluctSDK;

static NSString *const kGroupId = @"groupID";
static NSString *const kUnitId = @"unitID";

@interface ALFluctMediationAdapterParam : NSObject
- (instancetype)initWithParameters:(nonnull id<MAAdapterResponseParameters>)params;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *unitId;
@end

@implementation ALFluctMediationAdapterParam
- (instancetype)initWithParameters:(nonnull id<MAAdapterResponseParameters>)parameters {
    self = [super init];
    if (self) {
        if ([parameters.customParameters objectForKey:kGroupId] && [parameters.customParameters objectForKey:kUnitId]) {
            _groupId = parameters.customParameters[kGroupId];
            _unitId = parameters.customParameters[kUnitId];
        }
        NSString *placementIdentifier = parameters.thirdPartyAdPlacementIdentifier;
        NSArray<NSString *> *ids = [placementIdentifier componentsSeparatedByString:@","];
        if (ids.count == 2) {
            _groupId = ids[0];
            _unitId = ids[1];
        }
        if ([_groupId length] == 0 || [_unitId length] == 0) {
            return nil;
        }
    }
    return self;
}

@end

@interface ALFluctMediationAdapterRewardedVideoAdDelegate : NSObject <ALFluctRewardedVideoDelegateProxyItem>
@property (nonatomic, weak) ALFluctMediationAdapter *parentAdapter;
@property (nonatomic, strong) id<MARewardedAdapterDelegate> delegate;
- (instancetype)initWithParentAdapter:(ALFluctMediationAdapter *)parentAdapter andNotify:(id<MARewardedAdapterDelegate>)delegate;
@end

@interface ALFluctMediationAdapter ()

@property (nonatomic, strong) ALFluctMediationAdapterRewardedVideoAdDelegate *rewardedAdapterDelegate;

@end

@implementation ALFluctMediationAdapter
static ALAtomicBoolean *ALFluctInitialized;
static MAAdapterInitializationStatus ALFluctInitializationStatus = NSIntegerMin;

- (void)initializeWithParameters:(id<MAAdapterInitializationParameters>)parameters
               completionHandler:(void (^)(MAAdapterInitializationStatus initializationStatus, NSString *_Nullable errorMessage))completionHandler {

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        ALFluctInitialized = [[ALAtomicBoolean alloc] init];
    });

    if ([ALFluctInitialized compareAndSet:NO update:YES]) {
        [self log:@"Initializing FluctSDK..."];
        ALFluctInitializationStatus = MAAdapterInitializationStatusInitializing;

        FSSConfigurationOptions *options = FSSConfigurationOptions.defaultOptions;
        options.mediationPlatformType = FSSMediationPlatformTypeMax;
        options.mediationPlatformSDKVersion = ALSdk.version;
        [FluctSDK configureWithOptions:options];

        // Max SDKの設定とは別にFSSRewardedVideoSettingを利用することでtestMode/DebugModeの設定が可能
        // if ([parameters isTesting]) {
        //     // isTesting だとテスト広告しか表示されない
        //     FSSRewardedVideoSetting *setting = FSSRewardedVideoSetting.defaultSetting;
        //     setting.testMode = YES;
        //     setting.debugMode = YES;
        //     FSSRewardedVideo.sharedInstance.setting = setting;
        // }

        [self log:@"FluctSDK initialized"];

        ALFluctInitializationStatus = MAAdapterInitializationStatusInitializedSuccess;
        completionHandler(ALFluctInitializationStatus, nil);
    } else {
        [self log:@"FluctSDK attempted initialization already - marking initialization as %ld", ALFluctInitializationStatus];
        completionHandler(ALFluctInitializationStatus, nil);
    }
}

- (NSString *)SDKVersion {
    return [NSString stringWithFormat:@"%@.0", [FluctSDK version]];
}

- (NSString *)adapterVersion {
    return [NSString stringWithFormat:@"%@.0.0", [FluctSDK version]];
}

- (void)destroy {
    self.rewardedAdapterDelegate = nil;
}

#pragma mark - MARewardedAdapter

- (void)loadRewardedAdForParameters:(nonnull id<MAAdapterResponseParameters>)parameters
                          andNotify:(nonnull id<MARewardedAdapterDelegate>)delegate {

    if (![ALFluctMediationAdapter canDeliverAds:parameters]) {
        [delegate didFailToLoadRewardedAdWithError:[ALFluctMediationAdapter maxErrorFromFluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                                       code:FSSVideoErrorNoAds
                                                                                                                   userInfo:@{NSLocalizedDescriptionKey : @"FluctSDK dose not deliver ads to this user to comply with GDPR, CCPA, COPPA"}]]];
        return;
    }
    ALFluctMediationAdapterParam *param = [[ALFluctMediationAdapterParam alloc] initWithParameters:parameters];

    [self log:@"Loading rewarded ad for group id: %@, unit id: %@", param.groupId, param.unitId];

    if (!param) {
        [delegate didFailToLoadRewardedAdWithError:[ALFluctMediationAdapter maxErrorFromFluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                                       code:FSSVideoErrorBadRequest
                                                                                                                   userInfo:@{NSLocalizedDescriptionKey : @"FluctSDK dose not deliver ads to invalid group_id and/or unit_id"}]]];
        return;
    }

    self.rewardedAdapterDelegate = [[ALFluctMediationAdapterRewardedVideoAdDelegate alloc] initWithParentAdapter:self
                                                                                                       andNotify:delegate];
    [ALFluctRewardedVideoDelegateProxy.sharedInstance registerDelegate:self.rewardedAdapterDelegate
                                                               groupId:param.groupId
                                                                unitId:param.unitId];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FSSRewardedVideo.sharedInstance.delegate = ALFluctRewardedVideoDelegateProxy.sharedInstance;
    });

    [FSSRewardedVideo.sharedInstance loadRewardedVideoWithGroupId:param.groupId
                                                           unitId:param.unitId];
}

- (void)showRewardedAdForParameters:(nonnull id<MAAdapterResponseParameters>)parameters
                          andNotify:(nonnull id<MARewardedAdapterDelegate>)delegate {
    ALFluctMediationAdapterParam *param = [[ALFluctMediationAdapterParam alloc] initWithParameters:parameters];

    [self log:@"Showing rewarded ad for group id: %@, unit id: %@", param.groupId, param.unitId];

    [FSSRewardedVideo.sharedInstance presentRewardedVideoAdForGroupId:param.groupId
                                                               unitId:param.unitId
                                                   fromViewController:[ALUtils topViewControllerFromKeyWindow]];
    [delegate didDisplayRewardedAd];
}

#pragma mark - Utility Methods

+ (MAAdapterError *)maxErrorFromFluctError:(NSError *)error {

    NSInteger fluctErrorCode = error.code;
    MAAdapterError *adapterError = MAAdapterError.unspecified;
    switch (fluctErrorCode) {
    case FSSVideoErrorInitializeFailed:
        adapterError = MAAdapterError.notInitialized;
        break;
    case FSSVideoErrorLoadFailed:
    case FSSVideoErrorNotReady:
    case FSSVideoErrorPlayFailed:
        adapterError = MAAdapterError.adNotReady;
        break;
    case FSSVideoErrorNoAds:
        adapterError = MAAdapterError.noFill;
        break;
    case FSSVideoErrorBadRequest:
        adapterError = MAAdapterError.badRequest;
        break;
    case FSSVideoErrorWrongConfiguration:
    case FSSVideoErrorInvalidApp:
        adapterError = MAAdapterError.invalidConfiguration;
        break;
    case FSSVideoErrorNotConnectedToInternet:
        adapterError = MAAdapterError.noConnection;
        break;
    case FSSVideoErrorExpired:
        adapterError = MAAdapterError.adExpiredError;
        break;
    case FSSVideoErrorVastParseFailed:
        adapterError = MAAdapterError.invalidLoadState;
        break;
    case FSSVideoErrorTimeout:
        adapterError = MAAdapterError.timeout;
        break;
    case FSSVideoErrorUnknown:
    default:
        adapterError = MAAdapterError.unspecified;
        break;
    }

    return [MAAdapterError errorWithAdapterError:adapterError
                        mediatedNetworkErrorCode:fluctErrorCode
                     mediatedNetworkErrorMessage:error.localizedDescription];
}

+ (BOOL)canDeliverAds:(nonnull id<MAAdapterResponseParameters>)parameters {
    // GDPR
    NSNumber *userConsent = parameters.userConsent;
    bool canDeliverAdsForUserConsent = userConsent == nil || [userConsent boolValue];
    if (!canDeliverAdsForUserConsent) {
        return false;
    }

    // CCPA
    NSNumber *doNotSell = parameters.doNotSell;
    bool canDeliverAdsForDoNotSell = doNotSell == nil || ![doNotSell boolValue];
    if (!canDeliverAdsForDoNotSell) {
        return false;
    }

    return true;
}

@end

@implementation ALFluctMediationAdapterRewardedVideoAdDelegate

- (instancetype)initWithParentAdapter:(ALFluctMediationAdapter *)parentAdapter
                            andNotify:(id<MARewardedAdapterDelegate>)delegate {
    self = [super init];
    if (self) {
        self.parentAdapter = parentAdapter;
        self.delegate = delegate;
    }
    return self;
}

- (void)rewardedVideoShouldRewardForGroupID:(NSString *)groupId
                                     unitId:(NSString *)unitId {

    [self.parentAdapter log:@"Rewarded user for group id: %@, unit id: %@", groupId, unitId];
}

- (void)rewardedVideoDidLoadForGroupID:(NSString *)groupId
                                unitId:(NSString *)unitId {
    [self.parentAdapter log:@"Rewarded ad loaded for group id: %@, unit id: %@", groupId, unitId];
    [self.delegate didLoadRewardedAd];
}

- (void)rewardedVideoDidFailToLoadForGroupId:(NSString *)groupId
                                      unitId:(NSString *)unitId
                                       error:(NSError *)error {
    [self.parentAdapter log:@"Rewarded ad failed to load for group id: %@, unit id: %@, error: %@", groupId, unitId, error];
    [self.delegate didFailToLoadRewardedAdWithError:[ALFluctMediationAdapter maxErrorFromFluctError:error]];
}

- (void)rewardedVideoWillAppearForGroupId:(NSString *)groupId
                                   unitId:(NSString *)unitId {
    [self.parentAdapter log:@"Rewarded ad will appear for group id: %@, unit id: %@", groupId, unitId];
}

- (void)rewardedVideoDidAppearForGroupId:(NSString *)groupId
                                  unitId:(NSString *)unitId {
    [self.parentAdapter log:@"Rewarded ad appeared for group id: %@, unit id: %@", groupId, unitId];
    [self.delegate didDisplayRewardedAd];
}

- (void)rewardedVideoWillDisappearForGroupId:(NSString *)groupId
                                      unitId:(NSString *)unitId {
    [self.parentAdapter log:@"Rewarded ad will disappear for group id: %@, unit id: %@", groupId, unitId];
}

- (void)rewardedVideoDidDisappearForGroupId:(NSString *)groupId
                                     unitId:(NSString *)unitId {
    [self.parentAdapter log:@"Rewarded ad disappeared for group id: %@, unit id: %@", groupId, unitId];

    [self.delegate didRewardUserWithReward:[MAReward rewardWithAmount:MAReward.defaultAmount
                                                                label:MAReward.defaultLabel]];
    [self.delegate didHideRewardedAd];
}

- (void)rewardedVideoDidFailToPlayForGroupId:(NSString *)groupId
                                      unitId:(NSString *)unitId
                                       error:(NSError *)error {
    [self.parentAdapter log:@"Rewarded ad failed to play for group id: %@, unit id: %@, error: %@", groupId, unitId, error];
    [self.delegate didFailToDisplayRewardedAdWithError:[ALFluctMediationAdapter maxErrorFromFluctError:error]];
}

@end
