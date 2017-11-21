//
//  FSSAdRequestTargeting.h
//  FluctSDK
//
//  Created by 清 貴幸 on 2017/09/04.
//  Copyright © 2017年 fluct, Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface FSSAdRequestTargeting : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) CLLocation *location;

@end
