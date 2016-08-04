//
//  InterstitialViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2014 fluct, Inc. All rights reserved.
//

#import "InterstitialViewController.h"

@import FluctSDK;

@interface InterstitialViewController () <FluctInterstitialViewDelegate>

@property (nonatomic) FluctInterstitialView *interstitialView;
@end

@implementation InterstitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showInterstitial:(id)sender
{
    self.interstitialView = [[FluctInterstitialView alloc] init];
    [self.interstitialView setMediaID: @"0000000108"];
    self.interstitialView.delegate = self;
    [self.interstitialView showInterstitialAd];
    // 背景色を設定してインタースティシャル広告を表示する場合
    // [self.interstitialView showInterstitialAdWithHexColor: @"#FF0000"];
}

- (void)fluctInterstitialView:(FluctInterstitialView *)interstitialView callbackValue:(NSInteger)callbackValue
{
    NSLog(@"Interstitial callback : %ld", (long)callbackValue);

    switch (callbackValue) {
        case FluctInterstitialShow:
            NSLog(@"表示されました");
            break;
        case FluctInterstitialTap:
            NSLog(@"タップされました");
            break;
        case FluctInterstitialClose:
            NSLog(@"閉じました");
            break;
        case FluctInterstitialCancel:
            NSLog(@"キャンセルされました");
            break;
        case FluctInterstitialOffline:
            NSLog(@"圏外です");
            break;
        case FluctInterstitialMediaIDError:
            NSLog(@"メディアIDが不正な値です");
            break;
        case FluctInterstitialNoConfig:
            NSLog(@"メディアIDに設定されていません");
            break;
        case FluctInterstitialSizeError:
            NSLog(@"表示する端末のサイズより広告が大きいです");
            break;
        case FluctInterstitialGetConfigError:
            NSLog(@"広告情報が取得出来ませんでした");
            break;
        case FluctInterstitialOtherError:
            NSLog(@"その他のエラーです");
            break;
        default:
            break;
    }

}

// 画面の回転時にインタースティシャルを非表示にする
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.interstitialView dismissInterstitialAd];
}

@end
