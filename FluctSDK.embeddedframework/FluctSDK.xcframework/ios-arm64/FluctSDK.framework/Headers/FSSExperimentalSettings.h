//
//  FSSExperimentalSettings.h
//  FluctSDK
//
//  Copyright © 2026 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 実験的な機能の設定を行う。
 */
@interface FSSExperimentalSettings : NSObject

/**
 * バナー広告で新しいディスプレイアドサーバーを利用するかどうかを指定する。
 * @param enabled 新しいディスプレイアドサーバーを利用する
 */
+ (void)setNewBannerAdServerEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
