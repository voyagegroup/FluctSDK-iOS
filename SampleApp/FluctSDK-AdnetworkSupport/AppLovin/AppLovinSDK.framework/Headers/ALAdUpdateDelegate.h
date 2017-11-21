//
//  ALAdUpdateDelegate.h
//  sdk
//
//  Created by David Anderson on 10/1/12.
//
//

#import "ALAnnotations.h"
#import <Foundation/Foundation.h>

AL_ASSUME_NONNULL_BEGIN

@protocol ALAdUpdateObserver <NSObject>

- (void)adService:(ALAdService *)adService didUpdateAd:(alnullable ALAd *)ad;

- (BOOL)canAcceptUpdate;

@end

AL_ASSUME_NONNULL_END
