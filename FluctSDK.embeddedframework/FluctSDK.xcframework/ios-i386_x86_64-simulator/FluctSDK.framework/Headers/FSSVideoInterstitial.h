//
//  FSSVideoInterstitial.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import "FSSAdRequestTargeting.h"
#import "FSSVideoInterstitialSetting.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FSSVideoInterstitial;

/**
 * FSSVideoInterstitalのコールバック
 */
@protocol FSSVideoInterstitialDelegate <NSObject>

@optional

/**
 * 広告がロードされた時にコールされる。
 * @param interstitial  広告がロードされたFSSVideoInterstitial
 */
- (void)videoInterstitialDidLoad:(FSSVideoInterstitial *)interstitial;

/**
 * 広告のロードが失敗した時にコールされる。
 * @param interstitial  広告のロードが失敗したFSSVideoInterstitial
 * @param error         エラー
 */
- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToLoadWithError:(NSError *)error;

/**
 * 広告が表示される時にコールされる。
 * @param interstitial  表示されるFSSVideoInterstitial
 */
- (void)videoInterstitialWillAppear:(FSSVideoInterstitial *)interstitial;

/**
 * 広告が表示された後に時にコールされる。
 * @param interstitial  表示されたFSSVideoInterstitial
 */
- (void)videoInterstitialDidAppear:(FSSVideoInterstitial *)interstitial;

/**
 * 広告が閉じられる時にコールされる。
 * @param interstitial  閉じられるFSSVideoInterstitial
 */
- (void)videoInterstitialWillDisappear:(FSSVideoInterstitial *)interstitial;

/**
 * 広告が閉じられた時にコールされる。
 * @param interstitial  閉じられたFSSVideoInterstitial
 */
- (void)videoInterstitialDidDisappear:(FSSVideoInterstitial *)interstitial;

/**
 * 動画の再生に失敗した時のコールされる。
 * @param interstitial  再生に失敗したFSSVideoInterstitial
 * @param error         エラー
 */
- (void)videoInterstitial:(FSSVideoInterstitial *)interstitial didFailToPlayWithError:(NSError *)error;

@end

/**
 * 全画面動画広告の表示を行う。
 */
@interface FSSVideoInterstitial : NSObject

/**
 * グループID
 */
@property (nonatomic, readonly) NSString *groupId;

/**
 * ユニットID
 */
@property (nonatomic, readonly) NSString *unitId;

/**
 * 配信する広告の設定
 */
@property (nonatomic) FSSVideoInterstitialSetting *setting;

/**
 * デリゲート
 */
@property (nonatomic, weak, nullable) id<FSSVideoInterstitialDelegate> delegate;

/**
 * FSSVideoInterstitialの初期化を行う。
 * @param groupId   グループID
 * @param unitId    ユニットID
 * @param setting   配信する広告の設定
 */
- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId setting:(FSSVideoInterstitialSetting *)setting;

/**
 * 広告のロードを行う。
 */
- (void)loadAd;

/**
 * 広告のロードを行う。
 * @param targeting 広告を見るユーザーの情報
 */
- (void)loadAdWithTargeting:(FSSAdRequestTargeting *_Nullable)targeting;

/**
 * 広告のロードを行う。
 * @param adInfo 広告情報
 * @param requestedDate リクエストを開始した時間
 */
- (void)loadAdWithAdInfo:(NSDictionary<NSString *, id> *)adInfo requestedDate:(NSDate *)requestedDate;

/**
 * 全画面動画広告の再生準備ができているかを返す
 * @return 準備が完了している場合はYES、それ以外はNOを返す
 */
- (BOOL)hasAdAvailable;

/**
 * 全画面動画広告を表示する。
 * @param viewController    最前面のViewController
 */
- (void)presentAdFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
