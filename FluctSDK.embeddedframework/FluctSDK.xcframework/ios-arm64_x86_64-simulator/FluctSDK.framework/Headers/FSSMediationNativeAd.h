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
@property (nonatomic, readonly, copy, nullable) NSString *body;
@property (nonatomic, readonly, nullable) FSSNativeAdInformationIconView *informationIconView;

/// 広告が描画されたViewを渡してimpression計測を開始する。
/// Viewの表示を検知した時点でfluctのimpressionを送信し、completionを1回だけ呼ぶ。
/// あわせてviewable impression（MRC50/MRC100）も計測し、条件達成時にそれぞれのビーコンを送信する。
/// 再度呼ばれた場合は計測を新しいViewに張り替える（送信済みのイベントは再送しない）。
- (void)startImpressionTrackingWithView:(UIView *)view
                             completion:(nullable void (^)(void))completion;

/// セル再利用などでViewと広告の紐付けが切れた場合に計測を停止する
- (void)stopImpressionTracking;

/// 広告が描画されたViewへのタップ検知を開始する。
/// clickableViewsの領域へのタップを検知するとcompletionを呼んだ上でクリック処理（クリック計測・LP遷移）を行う。
/// clickableViewsが空の場合はView全体をクリック可能として扱う。
/// information icon（AdChoices）へのタップはクリックとして扱わない。
/// 再度呼ばれた場合は検知を新しいViewに張り替える。
- (void)startClickTrackingWithView:(UIView *)view
                    clickableViews:(NSArray<UIView *> *)clickableViews
                    viewController:(UIViewController *)viewController
                        completion:(nullable void (^)(void))completion;

/// セル再利用などでViewと広告の紐付けが切れた場合にタップ検知を停止する
- (void)stopClickTracking;

- (void)handleClickWithViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
