//
//  FSSConditionObserver.h
//  FluctSDK
//

#import <UIKit/UIKit.h>

typedef void (^completionHandler)(void);
typedef BOOL (^shouldCompletionBlock)(void);

NS_ASSUME_NONNULL_BEGIN
@interface FSSConditionObserver : NSObject

- (instancetype)initWithInterval:(NSTimeInterval)interval
                   fallbackLimit:(NSInteger)limit
               completionHandler:(completionHandler)completion
                 fallbackHandler:(completionHandler _Nullable)fallback
       shouldCompletionCondition:(shouldCompletionBlock)shouldCompletion;

- (void)start;
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
