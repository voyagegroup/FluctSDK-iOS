//
//  FSSMaio.h
//  FluctSDK
//
//  Copyright © 2024 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Maio/Maio.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FSSMaioProtocol

- (void)load:(NSString *)zoneId
        testMode:(BOOL)testMode
    loadCallback:(nullable id<MaioRewardedLoadCallback>)loadCallback;

- (void)show:(UIViewController *)viewController
    showCallback:(nullable id<MaioRewardedShowCallback>)showCallback;

@end

@interface FSSMaio : NSObject <FSSMaioProtocol>

- (void)load:(NSString *)zoneId
        testMode:(BOOL)testMode
    loadCallback:(nullable id<MaioRewardedLoadCallback>)loadCallback;

- (void)show:(UIViewController *)viewController
    showCallback:(nullable id<MaioRewardedShowCallback>)showCallback;

@end

NS_ASSUME_NONNULL_END
