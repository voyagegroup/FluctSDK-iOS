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

@property (nonatomic) FSSBannerView *topBannerView;

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
    
    self.topBannerView = [[FSSBannerView alloc] initWithFrame: CGRectMake(0, 100, 320, 50)];
    [self.topBannerView setMediaID:@"0000005617"];
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
