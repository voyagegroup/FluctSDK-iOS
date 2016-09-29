//
//  BannerNavigationController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

#import "BannerNavigationController.h"
#import <FluctSDK/FluctSDK.h>

@interface BannerNavigationController ()

@end

@implementation BannerNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    FSSBannerView *bannerView = [[FSSBannerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 100, 320, 50)];
    [bannerView setRootViewController:self];
    [bannerView setMediaID:@"0000005617"];
    [self.view addSubview:bannerView];
}

@end
