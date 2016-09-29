//
//  FluctSmartBannerView.h
//  FluctSDK
//
//  Created by 中川 慶悟 on 2016/08/26.
//  Copyright © 2016年 fluct, Inc. All rights reserved.
//

#import "FluctBannerView.h"


@interface FluctSmartBannerView : FluctBannerView
@property(nonatomic, getter=isSizeAdjust) IBInspectable BOOL sizeAdjust;
@end

@protocol FluctSmartBannerViewDelegate <NSObject>
@optional
- (void)fluctSmartBannerView:(FluctSmartBannerView *)bannerView
          callbackValue:(NSInteger)callbackValue;
@end