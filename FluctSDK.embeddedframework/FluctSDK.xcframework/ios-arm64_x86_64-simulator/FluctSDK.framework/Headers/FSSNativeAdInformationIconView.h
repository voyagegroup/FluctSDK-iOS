//
//  FSSNativeAdInformationIconView.h
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FSSNativeAdInformationIconPosition) {
    FSSNativeAdInformationIconPositionTopRight,
    FSSNativeAdInformationIconPositionTopLeft,
    FSSNativeAdInformationIconPositionBottomRight,
    FSSNativeAdInformationIconPositionBottomLeft,
};

@interface FSSNativeAdInformationIconView : UIView

// アイコンを寄せるコーナー。default は TopRight。
@property (nonatomic) FSSNativeAdInformationIconPosition position;

- (instancetype)init;
- (instancetype)initWithUrlString:(nonnull NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
