//
//  InterstitialViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2014 fluct, Inc. All rights reserved.
//

#import "InterstitialViewController.h"

@import FluctSDK;

@interface InterstitialViewController () <FSSInterstitialViewDelegate>

@property (nonatomic) FSSInterstitialView *interstitialView;
@end

@implementation InterstitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showInterstitial:(id)sender {
    self.interstitialView = [[FSSInterstitialView alloc] init];
    [self.interstitialView setMediaID:@"0000000108"];
    self.interstitialView.delegate = self;
    [self.interstitialView showInterstitialAd];
    // 背景色を設定してインタースティシャル広告を表示する場合
    // [self.interstitialView showInterstitialAdWithHexColor: @"#FF0000"];
}

- (void)interstitialView:(FSSInterstitialView *)interstitialView callbackType:(FSSInterstitialViewCallbackType)callbackType {
    NSLog(@"Interstitial callback : %ld", (long)callbackType);

    switch (callbackType) {
    case FSSInterstitialViewCallbackTypeShow:
        NSLog(@"表示されました");
        break;
    case FSSInterstitialViewCallbackTypeTap:
        NSLog(@"タップされました");
        break;
    case FSSInterstitialViewCallbackTypeClose:
        NSLog(@"閉じました");
        break;
    case FSSInterstitialViewCallbackTypeCancel:
        NSLog(@"キャンセルされました");
        break;
    case FSSInterstitialViewCallbackTypeOffline:
        NSLog(@"圏外です");
        break;
    case FSSInterstitialViewCallbackTypeMediaIDError:
        NSLog(@"メディアIDが不正な値です");
        break;
    case FSSInterstitialViewCallbackTypeNoConfig:
        NSLog(@"メディアIDに設定されていません");
        break;
    case FSSInterstitialViewCallbackTypeSizeError:
        NSLog(@"表示する端末のサイズより広告が大きいです");
        break;
    case FSSInterstitialViewCallbackTypeGetConfigError:
        NSLog(@"広告情報が取得出来ませんでした");
        break;
    case FSSInterstitialViewCallbackTypeOtherError:
        NSLog(@"その他のエラーです");
        break;
    default:
        break;
    }
}

@end
