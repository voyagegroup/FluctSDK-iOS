//
//  MovieBannerTableViewController.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2015年 fluct, Inc. All rights reserved.
//

#import "MovieBannerTableViewController.h"
#import "MovieBannerTableViewCell.h"

@interface MovieBannerTableViewController () <FluctBannerViewDelegate>
@property NSMutableArray *dataArray;
@end

@implementation MovieBannerTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.rowHeight = 110;
  self.dataArray = [NSMutableArray array];
  for (int i=0; i<20; i++) {
    NSString *labelTxt;
    if (i  == 10) {
      labelTxt = @"Banner";
    } else {
      labelTxt = @"Sample";
    }
    [self.dataArray addObject:[NSString stringWithFormat:@"%@%d", labelTxt, i]];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell;
  if ([[self.dataArray objectAtIndex:indexPath.row] rangeOfString:@"Banner"].location != NSNotFound) {
    MovieBannerTableViewCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:@"bannerCellIdentifier"];
    if (!bannerCell) {
      bannerCell = [[MovieBannerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bannerCellIdentifier"];
      [bannerCell.adView setMediaID:@"0000005096"];
      bannerCell.adView.delegate = self;
      [bannerCell.adView setRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    }
    cell = bannerCell;
  } else {
    UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"normalCellIdentifier"];
    if (!normalCell) {
      normalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalCellIdentifier"];
    }
    normalCell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell = normalCell;
  }
  return cell;
}

#pragma mark UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
  for (UITableViewCell *cell in self.tableView.visibleCells) {
    if ([cell class] == [MovieBannerTableViewCell class]) {
      [[(MovieBannerTableViewCell *)cell adView] scrollViewDidScroll];
    }
  }
}

@end
