//
//  FSSBannerView.h
//
//  Fluct SDK
//  Copyright 2011-2016 fluct, Inc. All rights reserved.
//

/*
 * バナー広告表示を行う
 * 事前にFluctSDKで表示設定処理を行う必要があります
 */

#import <UIKit/UIKit.h>

/**
 コールバックタイプ
 */
typedef NS_ENUM(NSInteger, FSSBannerViewCallbackType) {
    FSSBannerViewCallbackTypeLoad = 0,
    FSSBannerViewCallbackTypeTap = 1,
    FSSBannerViewCallbackTypeOffline = 2,
    FSSBannerViewCallbackTypeMediaIdError = 3,
    FSSBannerViewCallbackTypeNoConfig = 4,
    FSSBannerViewCallbackTypeGetConfigError = 5,
    FSSBannerViewCallbackTypeOtherError = 100
};

@protocol FSSBannerViewDelegate;

@class BannerWebView;
@interface FSSBannerView : UIView

@property (nonatomic, weak) id<FSSBannerViewDelegate> delegate;
@property (nonatomic, getter=isSizeAdjust) IBInspectable BOOL sizeAdjust;
- (id)init __attribute__((unavailable("FSSBannerView's init is not available")));
- (id)initWithFrame:(CGRect)frame sizeAdjust:(BOOL)sizeAdjust;

- (void)setMediaID:(NSString *)mediaID;
- (void)setRootViewController:(UIViewController *)rootViewController;
@end

@protocol FSSBannerViewDelegate <NSObject>
@optional
- (void)bannerView:(FSSBannerView *)bannerView callbackType:(FSSBannerViewCallbackType)callbackType;
@end