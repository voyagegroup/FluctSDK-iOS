//
//  FSSPangle.m
//  FluctSDKApp
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

#import "FSSPangle.h"

@implementation FSSPangle

- (void)startWithAppId:(NSString *)appId
                 debug:(BOOL)debugMode
     completionHandler:(nullable PAGAdsCompletionHandler)completionHandler {
    PAGConfig *config = [PAGConfig shareConfig];
    config.appID = appId;
    config.debugLog = debugMode;
    [PAGSdk startWithConfig:config
          completionHandler:completionHandler];
}

- (void)loadAdWithSlotID:(NSString *)slotID
       completionHandler:(PAGRewardedAdLoadCompletionHandler)completionHandler {
    PAGRewardedRequest *request = [PAGRewardedRequest request];
    [PAGRewardedAd loadAdWithSlotID:slotID
                            request:request
                  completionHandler:completionHandler];
}

@end
