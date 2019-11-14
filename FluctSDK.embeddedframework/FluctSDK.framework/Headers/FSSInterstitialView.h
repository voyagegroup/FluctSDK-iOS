//
//  FSSInterstitialView.h
//
//  Fluct SDK
//  Copyright 2011-2016 fluct, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FSSInterstitialViewCallbackType) {
    FSSInterstitialViewCallbackTypeShow = 0,
    FSSInterstitialViewCallbackTypeTap = 1,
    FSSInterstitialViewCallbackTypeClose = 2,
    FSSInterstitialViewCallbackTypeCancel = 3,
    FSSInterstitialViewCallbackTypeOffline = 4,
    FSSInterstitialViewCallbackTypeMediaIDError = 5,
    FSSInterstitialViewCallbackTypeNoConfig = 6,
    FSSInterstitialViewCallbackTypeSizeError = 7,
    FSSInterstitialViewCallbackTypeGetConfigError = 8,
    FSSInterstitialViewCallbackTypeOtherError = 100,
};

@protocol FSSInterstitialViewDelegate;

__attribute__((deprecated))
@interface FSSInterstitialView : UIView

- (id)init;
- (id)initWithMediaID:(NSString *)mediaID;
@property (nonatomic, copy, readwrite) NSString *mediaID;
- (void)showInterstitialAd;
- (void)showInterstitialAdWithHexColor:(NSString *)hexColorString;
- (void)dismissInterstitialAd;
@property (nonatomic, copy, readwrite) NSString *hexColorString;

@property (nonatomic, assign, readwrite) id<FSSInterstitialViewDelegate> delegate;

@end

__attribute__((deprecated))
@protocol FSSInterstitialViewDelegate<NSObject>

@optional
- (void)interstitialView:(FSSInterstitialView *)interstitialView callbackType:(FSSInterstitialViewCallbackType)callbackType;
@end