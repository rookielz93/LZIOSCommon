//
//  LZCond.m
//  PDDMediaCoreExtend
//
//  Created by jinshengli on 2023/3/22.
//

#import "LZCond.h"
#import "LZLock.h"

@interface LZCond ()
{
    dispatch_semaphore_t _cond;
}
@end

@implementation LZCond

- (instancetype)init {
    if (self = [super init]) {
        [self reset];
    }
    return self;
}

- (void)reset { _cond = dispatch_semaphore_create(0); }

- (void)signal { dispatch_semaphore_signal(_cond); }

- (void)wait { dispatch_semaphore_wait(_cond, DISPATCH_TIME_FOREVER); }

- (void)wait:(LZLock *)lock {
    [lock unLock];
    dispatch_semaphore_wait(_cond, DISPATCH_TIME_FOREVER);
    [lock lock];
}

@end
