//
//  FSSPangle.h
//  FluctSDKApp
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PAGAdSDK/PAGAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FSSPangleProtocol <NSObject>

- (void)startWithAppId:(NSString *)appId
                 debug:(BOOL)debugMode
     completionHandler:(nullable PAGAdsCompletionHandler)completionHandler;
- (void)loadAdWithSlotID:(NSString *)slotID
       completionHandler:(PAGRewardedAdLoadCompletionHandler)completionHandler;

@end

@interface FSSPangle : NSObject <FSSPangleProtocol>

- (void)startWithAppId:(NSString *)appId
                 debug:(BOOL)debugMode
     completionHandler:(nullable PAGAdsCompletionHandler)completionHandler;
- (void)loadAdWithSlotID:(NSString *)slotID
       completionHandler:(PAGRewardedAdLoadCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
