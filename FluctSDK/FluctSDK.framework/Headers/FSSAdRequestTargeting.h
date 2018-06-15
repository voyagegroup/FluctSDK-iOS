//
//  FSSAdRequestTargeting.h
//  FluctSDK
//
//  Created by 清 貴幸 on 2017/09/04.
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FSSGender) {
    FSSGenderUnknown = 0,
    FSSGenderMale,
    FSSGenderFemale
};

@interface FSSAdRequestTargeting : NSObject

@property (nonatomic, copy, nullable) NSString *userID;
@property (nonatomic, copy, nullable) CLLocation *location;
@property (nonatomic) FSSGender gender;
@property (nonatomic, copy, nullable) NSDate *birthday;
@property (nonatomic) NSInteger age;
@end

NS_ASSUME_NONNULL_END
