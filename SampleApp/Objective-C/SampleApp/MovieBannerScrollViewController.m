//
//  MovieBannerScrollViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2015年 fluct, Inc. All rights reserved.
//

#import "MovieBannerScrollViewController.h"
@import FluctSDK;

@interface MovieBannerScrollViewController () <FluctBannerViewDelegate, UIScrollViewDelegate>

@property UIScrollView *scrollView;
@property (nonatomic) FluctBannerView *bannerView;

@end

@implementation MovieBannerScrollViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 1500.0);
  self.scrollView.delegate = self;
  [self.view addSubview:self.scrollView];
  
  
  self.bannerView = [[FluctBannerView alloc] initWithFrame:CGRectMake(0.0, 700.0, 320.0, 170.0)];
  [self.bannerView setMediaID:@"0000005096"];
  self.bannerView.delegate = self;
  [self.scrollView addSubview:self.bannerView];
  [self.bannerView setRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
  
  UILabel *naviLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 260.0)/2,
                                                                 100.0,
                                                                 260.0,
                                                                 50.0)];
  naviLabel.text = @"下方向にスクロールしてください";
  [self.scrollView addSubview:naviLabel];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

# pragma mark FluctBannerView delegate method
- (void)fluctBannerView:(FluctBannerView *)bannerView
          callbackValue:(NSInteger)callbackValue {
  switch (callbackValue) {
    case FluctBannerLoad:
      // 広告が正常に読み込まれた場合の処理
      break;
    case FluctBannerOffline:
    case FluctBannerMediaIdError:
    case FluctBannerNoConfig:
    case FluctBannerGetConfigError:
    case FluctBannerOtherError:
      // いずれかの理由で広告表示ができない場合の処理
      break;
    default:
      break;
  }
}

#pragma mark UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.bannerView)
        [self.bannerView scrollViewDidScroll];
}



@end
