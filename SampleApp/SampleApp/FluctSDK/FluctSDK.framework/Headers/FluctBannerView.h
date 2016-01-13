//
//  FluctBannerView.h
//
//  Fluct SDK
//  Copyright 2011-2014 fluct, Inc. All rights reserved.
//

/*
 * バナー広告表示を行う
 * 事前にFluctSDKで表示設定処理を行う必要があります
 */

#import <UIKit/UIKit.h>

/**
 コールバックタイプ
 */
typedef NS_ENUM(NSInteger, FluctBannerViewCallbackType)
{
    FluctBannerLoad = 0,
    FluctBannerTap = 1,
    FluctBannerOffline = 2,
    FluctBannerMediaIdError = 3,
    FluctBannerNoConfig = 4,
    FluctBannerGetConfigError = 5,
    FluctBannerOtherError = 100
};

@protocol FluctBannerViewDelegate;

@class BannerWebView;

@interface FluctBannerView : UIView
{
@private
    BannerWebView *_bannerWebView;
    BOOL _initialized;
}

@property (nonatomic, retain) BannerWebView *bannerWebView;
@property (nonatomic, assign) id<FluctBannerViewDelegate> delegate;

- (void)setMediaID:(NSString *)mediaID;
- (void)setRootViewController:(UIViewController*)rootViewController;
- (void)scrollViewDidScroll;
- (void)playMovie;
- (void)pauseMovie;

@end

@protocol FluctBannerViewDelegate <NSObject>
@optional
- (void)fluctBannerView:(FluctBannerView *)bannerView
          callbackValue:(NSInteger)callbackValue;
@end
