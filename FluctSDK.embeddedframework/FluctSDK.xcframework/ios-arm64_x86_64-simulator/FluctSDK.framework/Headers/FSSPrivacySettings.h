//
//  FSSPrivacySettings.h
//  FluctSDK
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSSPrivacySettings : NSObject

/**
 * 児童オンライン保護法 (COPPA)の目的で子供向けとして扱うかどうかを指定する。
 * @param isChildDirectedTreatment 子供向けとして扱う
 */
+ (void)setIsChildDirectedTreatment:(BOOL)isChildDirectedTreatment;

/**
 * ユーザーがGDPRの同意年齢に達していないかどうかを指定する。
 * @param isUnderAgeOfConsent 同意年齢に達していない
 */
+ (void)setIsUnderAgeOfConsent:(BOOL)isUnderAgeOfConsent;

@end

NS_ASSUME_NONNULL_END
