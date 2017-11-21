//
//  FSSRewardedVideoMaioManager.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Maio/Maio.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MaioFailReasonExtend) {
    MaioFailReasonExtendLoadFailed = -1,
    MaioFailReasonExtendTimeout = -2
};

@protocol FSSRewardedVideoMaioManagerDelegate <NSObject>
- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue;
- (void)maioWillStartAd:(NSString *)zoneId;
- (void)maioDidFinishAd:(NSString *)zoneId
               playtime:(NSInteger)playtime
                skipped:(BOOL)skipped
            rewardParam:(NSString *)rewardParam;
- (void)maioDidClickAd:(NSString *)zoneId;
- (void)maioDidCloseAd:(NSString *)zoneId;
- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason;
@end

@interface FSSRewardedVideoMaioManager : NSObject <MaioDelegate>
+ (instancetype)sharedInstance;
- (void)loadRewardedVideoWithDictionary:(NSDictionary *)dictionary
                               delegate:(id<FSSRewardedVideoMaioManagerDelegate>)delegate
                               testMode:(BOOL)testMode;
- (void)presentRewardedVideoAdFromViewController:(UIViewController *)viewController zoneId:(NSString *)zoneId;
@end
NS_ASSUME_NONNULL_END
