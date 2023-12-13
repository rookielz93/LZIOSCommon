//
//  LZLock.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/11.
//

#import "LZLock.h"

@interface LZLock ()
{
    dispatch_semaphore_t _lock;
}
@end

@implementation LZLock

- (instancetype)init {
    if (self = [super init]) {
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)lock { dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); }

- (void)unLock { dispatch_semaphore_signal(_lock); }

@end
