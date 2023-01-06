//
//  FSSPangleLoadManager.m
//  FluctSDKApp
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

#import "FSSPangleLoadManager.h"
#import "FSSPangle.h"

typedef NS_ENUM(NSUInteger, FSSPangleInitilizationStatus) {
    FSSPangleNotInitilized,
    FSSPangleInitilizing,
    FSSPangleInitilized,
    FSSPangleInitilizationFailed,
};

@interface FSSPangleSlotDelegate : NSObject

@property (nonatomic) NSString *slotId;
@property (nonatomic) id<FSSPangleLoadManagerDelegate> delegate;

@end

@implementation FSSPangleSlotDelegate

- (instancetype)initWithSlotId:(NSString *)slotId
                      delegate:(id<FSSPangleLoadManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.slotId = slotId;
        self.delegate = delegate;
    }
    return self;
}

@end

@interface FSSPangleLoadManager ()

@property (nonatomic) FSSPangle *pangle;
@property (nonatomic) FSSPangleInitilizationStatus initilizationStatus;
@property (nonatomic) NSMutableArray<FSSPangleSlotDelegate *> *slotDelegateArray;
@property (nonatomic) NSError *initilizationFluctError;
@property (nonatomic) NSError *initilizationAdnetworkError;

@end

@implementation FSSPangleLoadManager

+ (instancetype)sharedInstance {
    static FSSPangleLoadManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithPangle:[FSSPangle new]];
    });

    return sharedInstance;
}

- (instancetype)initWithPangle:(id<FSSPangleProtocol>)pangle {
    self = [super init];
    if (self) {
        _pangle = pangle;
        _initilizationStatus = FSSPangleNotInitilized;
        _slotDelegateArray = [NSMutableArray new];
    }
    return self;
}

- (void)startWithAppId:(NSString *)appId
                 debug:(BOOL)debugMode {
    self.initilizationStatus = FSSPangleInitilizing;
    __weak __typeof(self) weakSelf = self;
    [self.pangle startWithAppId:appId
                          debug:debugMode
              completionHandler:^(BOOL success, NSError *_Nonnull error) {
                  if (success) {
                      [weakSelf initializationComplete];
                  } else {
                      [weakSelf initializationFailed:error];
                  }
              }];
}

- (void)loadWithAppId:(NSString *)AppId
            debugMode:(BOOL)debugMode
               slotId:(NSString *)slotId
             delegate:(id<FSSPangleLoadManagerDelegate>)delegate {
    if (self.initilizationStatus == FSSPangleNotInitilized) {
        self.initilizationStatus = FSSPangleInitilizing;
        [self.slotDelegateArray addObject:[[FSSPangleSlotDelegate alloc] initWithSlotId:slotId delegate:delegate]];
        [self startWithAppId:AppId debug:debugMode];
    } else if (self.initilizationStatus == FSSPangleInitilizing) {
        [self.slotDelegateArray addObject:[[FSSPangleSlotDelegate alloc] initWithSlotId:slotId delegate:delegate]];
    } else if (self.initilizationStatus == FSSPangleInitilized) {
        [self.slotDelegateArray addObject:[[FSSPangleSlotDelegate alloc] initWithSlotId:slotId delegate:delegate]];
        [self load];
    } else {
        [delegate pangleFailedToInitializeWithFluctError:self.initilizationFluctError
                                          adnetworkError:self.initilizationAdnetworkError];
    }
}

- (void)initializationComplete {
    self.initilizationStatus = FSSPangleInitilized;
    [self load];
}

- (void)initializationFailed:(NSError *)error {
    self.initilizationStatus = FSSPangleInitilizationFailed;
    self.initilizationAdnetworkError = error;
    self.initilizationFluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                       code:FSSVideoErrorInitializeFailed
                                                   userInfo:@{NSLocalizedDescriptionKey : @"initialization failed"}];

    [self.slotDelegateArray enumerateObjectsUsingBlock:^(FSSPangleSlotDelegate *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj.delegate pangleFailedToInitializeWithFluctError:self.initilizationFluctError
                                              adnetworkError:self.initilizationAdnetworkError];
    }];
    [self.slotDelegateArray removeAllObjects];
}

- (void)load {
    [self.slotDelegateArray enumerateObjectsUsingBlock:^(FSSPangleSlotDelegate *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.pangle loadAdWithSlotID:obj.slotId
                    completionHandler:^(PAGRewardedAd *_Nullable rewardedAd, NSError *_Nullable error) {
                        if (error) {
                            [obj.delegate pangleRewardedAdFailedToLoad:error];
                            return;
                        }
                        [obj.delegate pangleRewardedAdDidLoad:rewardedAd];
                    }];
    }];
    [self.slotDelegateArray removeAllObjects];
}

@end
