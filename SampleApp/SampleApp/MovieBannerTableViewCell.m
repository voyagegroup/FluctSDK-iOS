//
//  MovieBannerTableViewCell.m
//  SampleApp
//
//  Fluct SDK
//  Copyright (c) 2015年 fluct, Inc. All rights reserved.
//

#import "MovieBannerTableViewCell.h"

@implementation MovieBannerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  // Initialization code
  [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setup {
  self.adView = [[FluctBannerView alloc] initWithFrame:CGRectZero];
  [self.contentView addSubview:self.adView];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.adView.frame = CGRectMake(0, 0, 320, 110);
  [self.adView setNeedsLayout];
}
@end
