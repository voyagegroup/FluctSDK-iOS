//
//  FSSAdRequestTargeting.h
//  FluctSDK
//
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FSSGender) {
    FSSGenderUnknown = 0,
    FSSGenderMale,
    FSSGenderFemale
};

@interface FSSAdRequestTargeting : NSObject

@property (nonatomic, copy, nullable) NSString *userID __attribute__((deprecated));
@property (nonatomic, copy, nullable) NSDate *birthday;
@property (nonatomic) NSInteger age;
@property (nonatomic) FSSGender gender;
@end

NS_ASSUME_NONNULL_END
