//
//  NADVideo.h
//  NendAd
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface NADVideo : NSObject

@property (nonatomic, copy, nullable) NSString *mediationName;
@property (nonatomic, copy, nullable) NSString *userId;

@property (nonatomic, readonly, getter=isReady) BOOL ready;
@property (nonatomic) BOOL isOutputLog;

- (instancetype)initWithSpotId:(NSString *)spotId apiKey:(NSString *)apiKey NS_DESIGNATED_INITIALIZER;
- (void)loadAd;
- (void)showAdFromViewController:(UIViewController *)viewController;
- (void)releaseVideoAd;

@end
NS_ASSUME_NONNULL_END
