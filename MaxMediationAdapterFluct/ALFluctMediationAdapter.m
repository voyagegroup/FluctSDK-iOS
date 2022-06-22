//
//  FluctNetworkMediationAdapter.m
//  MaxMediationAdapterFluct
//
//

#import "ALFluctMediationAdapter.h"
@import FluctSDK;

static NSString *const kGroupId = @"groupID";
static NSString *const kUnitId = @"unitID";

@interface ALFluctMediationAdapterRewardedVideoAdDelegate : NSObject <FSSRewardedVideoDelegate>
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

        // isTesting だとテスト広告しか表示されないため、Fluctのsettingをする意味がないが念の為設定しています。
        FSSRewardedVideoSetting *setting = FSSRewardedVideoSetting.defaultSetting;

        if ([parameters isTesting]) {
            setting.testMode = YES;
            setting.debugMode = YES;
        }
        FSSRewardedVideo.sharedInstance.setting = setting;

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

    if ([ALFluctMediationAdapter shouldNotDeliverAds:parameters]) {
        [delegate didFailToLoadRewardedAdWithError:[ALFluctMediationAdapter maxErrorFromFluctError:[NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                                                                                       code:FSSVideoErrorNoAds
                                                                                                                   userInfo:@{NSLocalizedDescriptionKey : @"FluctSDK dose not deliver ads to this user to comply with GDPR, CCPA, COPPA"}]]];
        return;
    }

    NSString *placementIdentifier = parameters.thirdPartyAdPlacementIdentifier;
    NSString *groupID = parameters.customParameters[kGroupId];
    NSString *unitID = parameters.customParameters[kUnitId];

    [self log:@"Loading rewarded ad for placemet id: %@, group id: %@, unit id: %@", placementIdentifier, groupID, unitID];

    self.rewardedAdapterDelegate = [[ALFluctMediationAdapterRewardedVideoAdDelegate alloc] initWithParentAdapter:self
                                                                                                       andNotify:delegate];
    FSSRewardedVideo.sharedInstance.delegate = self.rewardedAdapterDelegate;

    [FSSRewardedVideo.sharedInstance loadRewardedVideoWithGroupId:groupID
                                                           unitId:unitID
                                                        targeting:[ALFluctMediationAdapter generateTargetingFromTargetData:ALSdk.shared.targetingData]];
}

- (void)showRewardedAdForParameters:(nonnull id<MAAdapterResponseParameters>)parameters
                          andNotify:(nonnull id<MARewardedAdapterDelegate>)delegate {
    NSString *placementIdentifier = parameters.thirdPartyAdPlacementIdentifier;
    NSString *groupID = parameters.customParameters[kGroupId];
    NSString *unitID = parameters.customParameters[kUnitId];

    [self log:@"Showing rewarded ad for placemet id: %@, group id: %@, unit id: %@", placementIdentifier, groupID, unitID];

    [FSSRewardedVideo.sharedInstance presentRewardedVideoAdForGroupId:groupID
                                                               unitId:unitID
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

+ (FSSAdRequestTargeting *_Nullable)generateTargetingFromTargetData:(ALTargetingData *_Nullable)targetData {
    if (!targetData) {
        return nil;
    }

    FSSAdRequestTargeting *targeting = [FSSAdRequestTargeting new];

    switch (targetData.gender) {
    case ALGenderFemale:
        targeting.gender = FSSGenderFemale;
        break;
    case ALGenderMale:
        targeting.gender = FSSGenderMale;
        break;
    case ALGenderUnknown:
    case ALGenderOther:
    default:
        targeting.gender = FSSGenderUnknown;
    }

    if (targetData.yearOfBirth) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:[targetData.yearOfBirth intValue]];
        targeting.birthday = [[NSCalendar currentCalendar] dateFromComponents:comps];
    }

    return targeting;
}

+ (BOOL)shouldNotDeliverAds:(nonnull id<MAAdapterResponseParameters>)parameters {
    NSNumber *gdpr = parameters.userConsent;
    NSNumber *ccpa = parameters.doNotSell;
    NSNumber *coppa = parameters.ageRestrictedUser;

    return ![gdpr boolValue] || [ccpa boolValue] || [coppa boolValue];
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
    [self.delegate didCompleteRewardedAdVideo];
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
    [self.delegate didStartRewardedAdVideo];
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
