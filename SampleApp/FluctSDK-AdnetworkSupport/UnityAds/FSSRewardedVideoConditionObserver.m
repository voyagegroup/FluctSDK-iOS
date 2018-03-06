//
//  FSSRewardedVideoConditionObserver.m
//  FluctSDK
//

#import "FSSRewardedVideoConditionObserver.h"

@interface FSSRewardedVideoConditionObserver ()
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSTimeInterval interval;

@property (nonnull, copy) completionHandler completion;
@property (nonnull, copy) completionHandler fallback;
@property (nonnull, copy) shouldCompletionBlock shouldCompletion;
@end

@implementation FSSRewardedVideoConditionObserver

- (instancetype)initWithInterval:(NSTimeInterval)interval
                   fallbackLimit:(NSInteger)limit
               completionHandler:(completionHandler)completion
                 fallbackHandler:(completionHandler)fallback
       shouldCompletionCondition:(shouldCompletionBlock)shouldCompletion {
    self = [super init];
    if (self) {
        self.limit = limit;
        self.interval = interval;
        self.completion = completion;
        self.fallback = fallback;
        self.shouldCompletion = shouldCompletion;
    }
    return self;
}

- (void)start {
    __weak __typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                 repeats:YES
                                                   block:^(NSTimer *_Nonnull timer) {
                                                       weakSelf.count += 1;
                                                       if (weakSelf.limit < weakSelf.count) {
                                                           if (weakSelf.fallback) {
                                                               weakSelf.fallback();
                                                           }
                                                           [weakSelf.timer invalidate];
                                                           return;
                                                       }

                                                       if (!weakSelf.shouldCompletion()) {
                                                           return;
                                                       }

                                                       weakSelf.completion();
                                                       [weakSelf.timer invalidate];
                                                   }];
}

- (void)invalidate {
    [self.timer invalidate];
}

@end
