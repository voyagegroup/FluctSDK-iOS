//
//  FluctInterstitialView.h
//
//  Fluct SDK
//  Copyright 2013-2014 fluct, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FluctInterstitialViewCallbackType) {
    FluctInterstitialShow = 0,
    FluctInterstitialTap = 1,
    FluctInterstitialClose = 2,
    FluctInterstitialCancel = 3,
    FluctInterstitialOffline = 4,
    FluctInterstitialMediaIDError = 5,
    FluctInterstitialNoConfig = 6,
    FluctInterstitialSizeError = 7,
    FluctInterstitialGetConfigError = 8,
    FluctInterstitialOtherError = 100,
};

@protocol FluctInterstitialViewDelegate;

__attribute__((deprecated("FluctInterstitialView is deprecated. You should use FSSInterstitialView.")))
@interface FluctInterstitialView : UIView

- (id)init;
- (id)initWithMediaID:(NSString *)mediaID;
@property (nonatomic, copy, readwrite) NSString *mediaID;

- (void)showInterstitialAd;
- (void)showInterstitialAdWithHexColor:(NSString *)hexColorString;
- (void)dismissInterstitialAd;
@property (nonatomic, copy, readwrite) NSString *hexColorString;

@property (nonatomic, assign, readwrite) id<FluctInterstitialViewDelegate> delegate;

@end

@protocol FluctInterstitialViewDelegate <NSObject>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@optional
- (void)fluctInterstitialView:(FluctInterstitialView *)interstitialView
                callbackValue:(NSInteger)callbackValue;
@end

#pragma clang diagnostic pop
