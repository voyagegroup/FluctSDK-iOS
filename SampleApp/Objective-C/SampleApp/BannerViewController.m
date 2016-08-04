//
//  BannerViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2014 fluct, Inc. All rights reserved.
//

#import "BannerViewController.h"

@import FluctSDK;

@interface BannerViewController ()

@property (nonatomic) FluctBannerView *topBannerView;

@end

@implementation BannerViewController

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
    self.topBannerView.frame = topBannerFrame;
    self.topBannerView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin |
                                           UIViewAutoresizingFlexibleLeftMargin |
                                           UIViewAutoresizingFlexibleRightMargin);
    [self.view addSubview:self.topBannerView];
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

@end
