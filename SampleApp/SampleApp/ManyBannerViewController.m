//
//  ManyBannerViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2014 fluct, Inc. All rights reserved.
//

#import "ManyBannerViewController.h"

#import <FluctSDK/FluctSDK.h>

@interface ManyBannerViewController () <FluctBannerViewDelegate>

@property (nonatomic) FluctBannerView *topBannerView;
@property (nonatomic) FluctBannerView *bottomBannerView;

@end

@implementation ManyBannerViewController

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
    // Do any additional setup after loading the view.
    self.topBannerView = [[FluctBannerView alloc] init];
    CGRect topBannerFrame = self.topBannerView.frame;
    topBannerFrame.origin.x = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(topBannerFrame)) / 2.0;
    self.topBannerView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin |
                                           UIViewAutoresizingFlexibleLeftMargin |
                                           UIViewAutoresizingFlexibleRightMargin);
    self.topBannerView.delegate = self;
    self.topBannerView.tag = 100;
    [self.view addSubview:self.topBannerView];
    
    CGRect bottomBannerFrame = CGRectMake(0.0, 0.0, 320.0, 50.0);
    bottomBannerFrame.origin.x = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(bottomBannerFrame)) / 2.0;
    bottomBannerFrame.origin.y = CGRectGetMaxY(self.view.bounds) - CGRectGetHeight(bottomBannerFrame);
    self.bottomBannerView = [[FluctBannerView alloc] initWithFrame:bottomBannerFrame];
    self.bottomBannerView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                              UIViewAutoresizingFlexibleLeftMargin |
                                              UIViewAutoresizingFlexibleRightMargin);
    self.bottomBannerView.delegate = self;
    self.bottomBannerView.tag = 200;
    [self.view addSubview:self.bottomBannerView];
}

- (void)viewWillLayoutSubviews
{
    CGFloat length = 0;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        length = [[self topLayoutGuide] length];
    }
    
    CGRect frame = self.topBannerView.frame;
    frame.origin.y = length;
    self.topBannerView.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark FluctBannerView delegate method
- (void)fluctBannerView:(FluctBannerView *)bannerView
          callbackValue:(NSInteger)callbackValue {
  switch (callbackValue) {
    case FluctBannerLoad:
      // 広告が正常に読み込まれた場合の処理
      NSLog(@"bannerView tag : %d", (int)bannerView.tag);
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

@end
