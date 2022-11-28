//
//  FSSUnityAdsManager.m
//  FluctSDK
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

#import "FSSUnityAdsManager.h"

typedef NS_ENUM(NSUInteger, FSSUnityAdsInitilizationStatus) {
    FSSUnityAdsNotInitilized,
    FSSUnityAdsInitilizing,
    FSSUnityAdsInitilized,
    FSSUnityAdsInitilizationFailed,
};

@interface FSSUnityAdsPlacementDelegate : NSObject

@property (nonatomic) NSString *placemantId;
@property (nonatomic) id<FSSUnityAdsManagerDelegate> delegate;

@end

@implementation FSSUnityAdsPlacementDelegate

- (instancetype)initWithPlacementId:(NSString *)placementId
                           delegate:(id<FSSUnityAdsManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.placemantId = placementId;
        self.delegate = delegate;
    }
    return self;
}

@end

@interface FSSUnityAdsManager () <UnityAdsInitializationDelegate>

@property (nonatomic) id<FSSUnityAdsProtocol> unityAds;
@property (nonatomic) NSMutableArray<FSSUnityAdsPlacementDelegate *> *placementDelegateArray;
@property (nonatomic) FSSUnityAdsInitilizationStatus initilizationStatus;
@property (nonatomic) NSError *initilizationFluctError;
@property (nonatomic) NSError *initilizationAdnetworkError;

@end

@implementation FSSUnityAdsManager

+ (instancetype)sharedInstanceWithUnityAds:(id<FSSUnityAdsProtocol>)unityAds {
    static FSSUnityAdsManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithUnityAds:unityAds];
    });

    return sharedInstance;
}

- (instancetype)initWithUnityAds:(id<FSSUnityAdsProtocol>)unityAds {
    self = [super init];
    if (self) {
        self.unityAds = unityAds;
        self.placementDelegateArray = [[NSMutableArray alloc] init];
        self.initilizationStatus = FSSUnityAdsNotInitilized;
    }
    return self;
}

- (void)loadWithGameId:(NSString *)gameId
              testMode:(BOOL)testMode
             debugMode:(BOOL)debugMode
           placementId:(NSString *)placementId
              delegate:(id<FSSUnityAdsManagerDelegate>)delegate {
    if (self.initilizationStatus == FSSUnityAdsNotInitilized) {
        self.initilizationStatus = FSSUnityAdsInitilizing;
        [self.placementDelegateArray addObject:[[FSSUnityAdsPlacementDelegate alloc] initWithPlacementId:placementId delegate:delegate]];
        [UnityAds setDebugMode:debugMode];
        [self.unityAds initialize:gameId testMode:testMode initializationDelegate:self];
    } else if (self.initilizationStatus == FSSUnityAdsInitilizing) {
        [self.placementDelegateArray addObject:[[FSSUnityAdsPlacementDelegate alloc] initWithPlacementId:placementId delegate:delegate]];
    } else if (self.initilizationStatus == FSSUnityAdsInitilized) {
        [self.unityAds load:placementId loadDelegate:delegate];
    } else {
        [delegate unityAdsFailedToInitializeWithFluctError:self.initilizationFluctError
                                            adnetworkError:self.initilizationAdnetworkError];
    }
}

#pragma mark UnityAdsInitializationDelegate

- (void)initializationComplete {
    self.initilizationStatus = FSSUnityAdsInitilized;
    [self.placementDelegateArray enumerateObjectsUsingBlock:^(FSSUnityAdsPlacementDelegate *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.unityAds load:obj.placemantId loadDelegate:obj.delegate];
    }];
    [self.placementDelegateArray removeAllObjects];
}

- (void)initializationFailed:(UnityAdsInitializationError)error withMessage:(nonnull NSString *)message {
    self.initilizationStatus = FSSUnityAdsInitilizationFailed;
    self.initilizationAdnetworkError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                           code:error
                                                       userInfo:@{NSLocalizedDescriptionKey : message}];
    self.initilizationFluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                       code:FSSVideoErrorInitializeFailed
                                                   userInfo:@{NSLocalizedDescriptionKey : message}];

    [self.placementDelegateArray enumerateObjectsUsingBlock:^(FSSUnityAdsPlacementDelegate *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj.delegate unityAdsFailedToInitializeWithFluctError:self.initilizationFluctError
                                                adnetworkError:self.initilizationAdnetworkError];
    }];
    [self.placementDelegateArray removeAllObjects];
}

@end
