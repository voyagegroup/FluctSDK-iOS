//
//  ManyBannerViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2014 fluct, Inc. All rights reserved.
//

#import "ManyBannerViewController.h"

@import FluctSDK;

@interface ManyBannerViewController () <FluctBannerViewDelegate>

@property (nonatomic) FluctBannerView *bottomBannerView;
@property (weak, nonatomic) IBOutlet FluctBannerView *topBannerView;

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
- (void)fluctBannerView:(FluctBannerView *)bannerView callbackValue:(NSInteger)callbackValue
{
    NSLog(@"bannerView : %ld", (long)callbackValue);
    switch (callbackValue) {
        case FluctBannerLoad:
            NSLog(@"読み込まれました");
            break;
        case FluctBannerOffline:
            NSLog(@"圏外です");
            break;
        case FluctBannerMediaIdError:
            NSLog(@"メディアIDが不正な値です");
            break;
        case FluctBannerNoConfig:
            NSLog(@"広告情報を取得出来ませんでした");
            break;
        case FluctBannerGetConfigError:
            NSLog(@"広告設定情報を取得出来ませんでした");
            break;
        case FluctBannerOtherError:
            NSLog(@"その他のエラーです");
            break;
        default:
          break;
    }
}

@end
