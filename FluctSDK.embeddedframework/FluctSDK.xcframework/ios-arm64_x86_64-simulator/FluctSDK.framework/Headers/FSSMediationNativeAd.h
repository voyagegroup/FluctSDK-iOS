//
//  FSSMediationNativeAd.h
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import "FSSMediaContent.h"
#import "FSSNativeAdInformationIconView.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSSMediationNativeAd : NSObject

@property (nonatomic, readonly, nonnull) FSSMediaContent *mediaContent;
@property (nonatomic, readonly, copy, nullable) NSString *headline;
@property (nonatomic, readonly, copy, nullable) NSString *advertiser;
@property (nonatomic, readonly, copy, nullable) NSString *callToAction;
@property (nonatomic, readonly, nullable) FSSNativeAdInformationIconView *informationIconView;

/// 広告が描画されたViewを渡してimpression計測を開始する。
/// Viewの表示を検知した時点でfluctのimpressionを送信し、completionを1回だけ呼ぶ。
/// あわせてviewable impression（MRC50/MRC100）も計測し、条件達成時にそれぞれのビーコンを送信する。
/// 再度呼ばれた場合は計測を新しいViewに張り替える（送信済みのイベントは再送しない）。
- (void)startImpressionTrackingWithView:(UIView *)view
                             completion:(nullable void (^)(void))completion;

/// セル再利用などでViewと広告の紐付けが切れた場合に計測を停止する
- (void)stopImpressionTracking;

- (void)handleClickWithViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
