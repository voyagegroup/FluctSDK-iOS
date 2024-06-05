//
//  FSSRewardedVideoAppLovinManager.m
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import "FSSRewardedVideoAppLovinManager.h"

typedef NS_ENUM(NSUInteger, FSSAppLovinInitilizationStatus) {
    FSSAppLovinNotInitilized,
    FSSAppLovinInitilizing,
    FSSAppLovinInitilized,
    FSSAppLovinInitilizationFailed,
};

@interface FSSAppLovinZoneDelegate : NSObject

@property (nonatomic) NSString *zoneName;
@property (nonatomic) id<FSSAppLovinProtocol> appLovin;
@property (nonatomic) id<FSSRewardedVideoAppLovinManagerDelegate> delegate;

@end

@implementation FSSAppLovinZoneDelegate

- (instancetype)initWithZoneName:(NSString *)zoneName
                        appLovin:(id<FSSAppLovinProtocol>)appLovin
                        delegate:(id<FSSRewardedVideoAppLovinManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.zoneName = zoneName;
        self.appLovin = appLovin;
        self.delegate = delegate;
    }
    return self;
}

@end

@interface FSSRewardedVideoAppLovinManager ()
@property (nonatomic) NSMutableArray<FSSAppLovinZoneDelegate *> *zoneDelegateArray;
@property (nonatomic) FSSAppLovinInitilizationStatus initilizationStatus;
@property (nonatomic) NSError *initilizationFluctError;
@property (nonatomic) NSError *initilizationAdnetworkError;
@end

@implementation FSSRewardedVideoAppLovinManager

+ (instancetype)sharedInstance {
    static FSSRewardedVideoAppLovinManager *sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _zoneDelegateArray = [NSMutableArray new];
        _initilizationStatus = FSSAppLovinNotInitilized;
    }
    return self;
}

- (void)loadRewardedVideoWithSdkKey:(NSString *)sdkKey
                           zoneName:(NSString *)zoneName
                           appLovin:(id<FSSAppLovinProtocol>)appLovin
                           delegate:(id<FSSRewardedVideoAppLovinManagerDelegate>)delegate
                           testMode:(BOOL)testMode {

    if (self.initilizationStatus == FSSAppLovinNotInitilized) {
        self.initilizationStatus = FSSAppLovinInitilizing;
        [self.zoneDelegateArray addObject:[[FSSAppLovinZoneDelegate alloc] initWithZoneName:zoneName appLovin:appLovin delegate:delegate]];
        [appLovin initializeWithSdkKey:sdkKey
                     completionHandler:^(BOOL sucsess) {
                         if (sucsess) {
                             [self initializationComplete];
                         } else {
                             [self initializationFailed];
                         }
                     }];

    } else if (self.initilizationStatus == FSSAppLovinInitilizing) {
        [self.zoneDelegateArray addObject:[[FSSAppLovinZoneDelegate alloc] initWithZoneName:zoneName appLovin:appLovin delegate:delegate]];
    } else if (self.initilizationStatus == FSSAppLovinInitilized) {
        [self.zoneDelegateArray addObject:[[FSSAppLovinZoneDelegate alloc] initWithZoneName:zoneName appLovin:appLovin delegate:delegate]];
        [self load];
    } else {
        [delegate appLovinFailedToInitializeWithFluctError:self.initilizationFluctError adnetworkError:self.initilizationAdnetworkError];
    }
}

- (void)initializationComplete {
    self.initilizationStatus = FSSAppLovinInitilized;
    [self load];
}

- (void)initializationFailed {
    NSString *mesasge = @"initialization failed";
    self.initilizationStatus = FSSAppLovinInitilizationFailed;
    self.initilizationAdnetworkError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                           code:AppLovinFailReasonExtendLoadFailed
                                                       userInfo:@{NSLocalizedDescriptionKey : mesasge}];
    self.initilizationFluctError = [NSError errorWithDomain:FSSVideoErrorSDKDomain
                                                       code:FSSVideoErrorInitializeFailed
                                                   userInfo:@{NSLocalizedDescriptionKey : mesasge}];

    [self.zoneDelegateArray enumerateObjectsUsingBlock:^(FSSAppLovinZoneDelegate *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj.delegate appLovinFailedToInitializeWithFluctError:self.initilizationFluctError
                                                adnetworkError:self.initilizationAdnetworkError];
    }];
    [self.zoneDelegateArray removeAllObjects];
}

- (void)load {
    [self.zoneDelegateArray enumerateObjectsUsingBlock:^(FSSAppLovinZoneDelegate *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj.appLovin load:obj.zoneName loadDelegate:obj.delegate];
    }];
    [self.zoneDelegateArray removeAllObjects];
}

@end
