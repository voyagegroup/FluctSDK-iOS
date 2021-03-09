//
//  FSSAdView.h
//  FluctSDK
//
//  Copyright © 2019 fluct, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

struct FSSAdSize {
    CGSize size;
};

typedef struct FSSAdSize FSSAdSize;

/**
 * 320x50を表すサイズ
 */
extern FSSAdSize const FSSAdSize320x50;
/**
 * 300x250を表すサイズ
 */
extern FSSAdSize const FSSAdSize300x250;
/**
 * 320x100を表すサイズ
 */
extern FSSAdSize const FSSAdSize320x100;

@class FSSAdView;

/**
 * FSSAdViewのコールバック
 */
@protocol FSSAdViewDelegate <NSObject>
@optional
/**
 * 広告がロードされたときにコールされる。
 * @param adView 広告がロードされたFSSAdView
 */
- (void)adViewDidStoreAd:(FSSAdView *)adView;

/*
 * 広告のロードが失敗したときにコールされる。
 * @param adView 広告のロードが失敗したFSSAdView
 * @param error エラー
 */
- (void)adView:(FSSAdView *)adView didFailToStoreAdWithError:(NSError *)error;

/*
 * 広告に対するアクションにより、アプリケーションから離れるときにコールされる。
 * @param adView 広告がロードされたFSSAdView
 */
- (void)willLeaveApplicationForAdView:(FSSAdView *)adView NS_SWIFT_NAME(willLeaveApplicationForAdView(_:));
@end

/**
 * FSSAdViewはバナー広告の表示を行う。
 */
@interface FSSAdView : UIView

/**
 * グループID
 */
@property (nonatomic, readonly) NSString *groupId;

/**
 * ユニットID
 */
@property (nonatomic, readonly) NSString *unitId;

/**
 * 広告サイズ
 */
@property (nonatomic, readonly) FSSAdSize adSize;

/**
 * デリゲート
 */
@property (nonatomic, nullable, weak) id<FSSAdViewDelegate> delegate;

/**
 * FSSAdViewの初期化を行う。
 * @param groupId グループID
 * @param unitId ユニットID
 * @param adSize 広告サイズ
 */
- (instancetype)initWithGroupId:(NSString *)groupId
                         unitId:(NSString *)unitId
                         adSize:(FSSAdSize)adSize;

/**
 * FSSAdViewの初期化を行う。
 * @param groupId グループID
 * @param unitId ユニットID
 * @param size 広告サイズ
 */
- (instancetype)initWithGroupId:(NSString *)groupId
                         unitId:(NSString *)unitId
                           size:(CGSize)size;

/**
 * FSSAdViewの初期化を行う。
 * @param groupId グループID
 * @param unitId ユニットID
 * @param size 広告サイズ
 * @param adInfo 広告情報
 */
- (instancetype)initWithGroupId:(NSString *)groupId
                         unitId:(NSString *)unitId
                           size:(CGSize)size
                         adInfo:(NSDictionary<NSString *, id> *)adInfo;

/**
 * 広告のロードを行う。
 */
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
