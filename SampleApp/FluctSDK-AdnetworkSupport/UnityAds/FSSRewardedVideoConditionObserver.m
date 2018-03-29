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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                  target:self
                                                selector:@selector(notifyIfPossible)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)notifyIfPossible {
    self.count += 1;
    if (self.limit < self.count) {
        if (self.fallback) {
            self.fallback();
        }
        [self.timer invalidate];
        return;
    }

    if (!self.shouldCompletion()) {
        return;
    }

    self.completion();
    [self.timer invalidate];
}

- (void)invalidate {
    [self.timer invalidate];
}

@end
