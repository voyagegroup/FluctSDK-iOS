//
//  FSSNativeView.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FSSErrorType) {
    FSSErrorTypeNoAd,
    FSSErrorTypeBadRequest,
    FSSErrorTypeNetworkConnection,
    FSSErrorTypeServerError,
    FSSErrorTypeOther
};

typedef NS_ENUM(NSInteger, FSSNativeViewCallbackType) {
    FSSNativeViewCallbackTypeLoadFinish,
    FSSNativeViewCallbackTypeTap
};

@protocol FSSNativeViewDelegate;

@interface FSSNativeView : UIView <UIWebViewDelegate>

NS_ASSUME_NONNULL_BEGIN
@property (nullable, nonatomic, weak) id<FSSNativeViewDelegate> delegate;

- (id)init __attribute__((unavailable("FSSNativeView's init is not available")));
- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame groupID:(NSString *)groupID unitID:(NSString *)unitID;

- (void)setGroupID:(NSString *)groupID unitID:(NSString *)unitID;
- (void)loadRequest;
@end

@protocol FSSNativeViewDelegate <NSObject>
@optional
- (void)nativeView:(FSSNativeView *)nativeView callbackType:(FSSNativeViewCallbackType)callbackType;
- (void)nativeView:(FSSNativeView *)nativeView callbackErrorType:(FSSErrorType)callbackErrorType;
@end
NS_ASSUME_NONNULL_END
