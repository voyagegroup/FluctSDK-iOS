//
//  ManyBannerViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2014 fluct, Inc. All rights reserved.
//

#import "ManyBannerViewController.h"

@import FluctSDK;

@interface ManyBannerViewController () <FSSBannerViewDelegate>

@property (nonatomic) FSSBannerView *bottomBannerView;
@property (weak, nonatomic) IBOutlet FSSBannerView *topBannerView;

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
    [self.topBannerView setMediaID:@"0000005617"];
    
    self.bottomBannerView = [[FSSBannerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 100, 320, 50)];
    self.bottomBannerView.delegate = self;
    [self.bottomBannerView setMediaID:@"0000005617"];
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
- (void)bannerView:(FSSBannerView *)bannerView callbackType:(FSSBannerViewCallbackType)callbackType
{
    NSLog(@"bannerView : %ld", (long)callbackType);
    switch (callbackType) {
        case FSSBannerViewCallbackTypeLoad:
            NSLog(@"読み込まれました");
            break;
        case FSSBannerViewCallbackTypeOffline:
            NSLog(@"圏外です");
            break;
        case FSSBannerViewCallbackTypeMediaIdError:
            NSLog(@"メディアIDが不正な値です");
            break;
        case FSSBannerViewCallbackTypeNoConfig:
            NSLog(@"広告情報を取得出来ませんでした");
            break;
        case FSSBannerViewCallbackTypeGetConfigError:
            NSLog(@"広告設定情報を取得出来ませんでした");
            break;
        case FSSBannerViewCallbackTypeOtherError:
            NSLog(@"その他のエラーです");
            break;
        default:
          break;
    }
}

@end
