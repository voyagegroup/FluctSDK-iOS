//
//  InterstitialViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2014 fluct, Inc. All rights reserved.
//

#import "InterstitialViewController.h"

#import <FluctSDK/FluctSDK.h>

@interface InterstitialViewController () <FluctInterstitialViewDelegate>

@property (nonatomic) FluctInterstitialView *interstitialView;
- (void) recursiveRequest;
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInterstitial:(id)sender
{
    [self performSelector:@selector(recursiveRequest) withObject:nil afterDelay:0.5f];
}

- (void) recursiveRequest
{
    if (!self.interstitialView) {
        self.interstitialView = [[FluctInterstitialView alloc] init];
        self.interstitialView.delegate = self;
    }
    [self.interstitialView showInterstitialAd];
}

- (void)fluctInterstitialView:(FluctInterstitialView *)interstitialView
                callbackValue:(NSInteger)callbackValue
{
    NSLog(@"Interstitial callback : %ld", (long)callbackValue);
    
    switch (callbackValue) {
        case FluctInterstitialShow:
            break;
        case FluctInterstitialTap:
            break;
        case FluctInterstitialClose:
        {
            self.interstitialView.delegate = nil;
            self.interstitialView = nil;
            break;
        }
        case FluctInterstitialCancel:
        {
            self.interstitialView.delegate = nil;
            self.interstitialView = nil;
            break;
        }
        case FluctInterstitialOffline:
        {
            self.interstitialView.delegate = nil;
            self.interstitialView = nil;
            break;
        }
        case FluctInterstitialMediaIDError:
        {
            self.interstitialView.delegate = nil;
            self.interstitialView = nil;
            break;
        }
        case FluctInterstitialNoConfig:
        {
            self.interstitialView.delegate = nil;
            self.interstitialView = nil;
            break;
        }
        case FluctInterstitialSizeError:
        {
            self.interstitialView.delegate = nil;
            self.interstitialView = nil;
            break;
        }
        case FluctInterstitialGetConfigError:
        {
            self.interstitialView.delegate = nil;
            self.interstitialView = nil;
            break;
        }
        case FluctInterstitialOtherError:
        {
            self.interstitialView.delegate = nil;
            self.interstitialView = nil;
            break;
        }
        default:
            break;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.interstitialView dismissInterstitialAd];
    self.interstitialView = nil;
}

@end
