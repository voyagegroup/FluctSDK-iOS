//
//  ALFluctAdViewAdapter.m
//  MaxMediationAdapterFluct
//
//

#import "ALFluctAdViewAdapter.h"
#import "ALFluctMediationAdapterError.h"
#import "ALFluctMediationAdapterParam.h"
#import "ALFluctMediationAdapterUtility.h"
@import FluctSDK;

@interface ALFluctAdViewAdapter () <FSSAdViewDelegate>
@property (nonatomic, strong) FSSAdView *adView;
@property (nonatomic, weak) id<MAAdViewAdapterDelegate> delegate;
@property (nonatomic, weak) ALFluctMediationAdapter *parentAdapter;
@end

@implementation ALFluctAdViewAdapter
- (void)loadAdViewAdapterWithAdapter:(ALFluctMediationAdapter *)adapter
                          parameters:(id<MAAdapterResponseParameters>)parameters
                            adFormat:(MAAdFormat *)adFormat
                           andNotify:(id<MAAdViewAdapterDelegate>)delegate {
    self.parentAdapter = adapter;
    if (![ALFluctMediationAdapterUtility canDeliverAds:parameters]) {
        [delegate didFailToLoadAdViewAdWithError:[ALFluctMediationAdapterError maxErrorFromFluctAdViewError:[NSError errorWithDomain:FSSBannerAdsSDKDomain
                                                                                                                                code:FSSAdViewErrorNoAds
                                                                                                                            userInfo:@{NSLocalizedDescriptionKey : @"FluctSDK dose not deliver ads to this user to comply with GDPR, CCPA"}]]];
        return;
    }
    ALFluctMediationAdapterParam *param = [[ALFluctMediationAdapterParam alloc] initWithParameters:parameters useCustomParameters:NO];
    [self.parentAdapter log:@"Loading AdView for group id: %@, unit id: %@", param.groupId, param.unitId];
    if (!param) {
        [delegate didFailToLoadAdViewAdWithError:[ALFluctMediationAdapterError maxErrorFromFluctAdViewError:[NSError errorWithDomain:FSSBannerAdsSDKDomain
                                                                                                                                code:FSSAdViewErrorBadRequest
                                                                                                                            userInfo:@{NSLocalizedDescriptionKey : @"FluctSDK dose not deliver ads to invalid group_id and/or unit_id"}]]];
        return;
    }
    self.delegate = delegate;
    self.adView = [[FSSAdView alloc] initWithGroupId:param.groupId
                                              unitId:param.unitId
                                              adSize:[ALFluctAdViewAdapter convertMAAdFormat:adFormat]];
    self.adView.delegate = self;
    [self.adView loadAd];
}

+ (FSSAdSize)convertMAAdFormat:(MAAdFormat *)adFormat {
    FSSAdSize fssAdSize;
    fssAdSize.size = adFormat.size;
    return fssAdSize;
}

#pragma mark - FSSAdViewDelegate

- (void)adViewDidStoreAd:(FSSAdView *)adView {
    [self.parentAdapter log:@"AdView did store for group id: %@, unit id: %@", adView.groupId, adView.unitId];
    [self.delegate didLoadAdForAdView:adView];
    __weak typeof(self) weakSelf = self;
    // didDisplayが呼ばれない問題の対応のためdidDisplayAdViewAdを遅延実行しています
    // 遅延時間が短いと正常にdidDisplayが呼ばれません
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf.delegate didDisplayAdViewAd];
    });
}

- (void)adView:(FSSAdView *)adView didFailToStoreAdWithError:(NSError *)error {
    [self.parentAdapter log:@"AdView failed to store for group id: %@, unit id: %@, error: %@", adView.groupId, adView.unitId, error];
    [self.delegate didFailToLoadAdViewAdWithError:[ALFluctMediationAdapterError maxErrorFromFluctAdViewError:error]];
}

- (void)willLeaveApplicationForAdView:(FSSAdView *)adView {
    [self.parentAdapter log:@"AdView will leave application for group id: %@, unit id: %@", adView.groupId, adView.unitId];
    [self.delegate didClickAdViewAd];
}
@end
