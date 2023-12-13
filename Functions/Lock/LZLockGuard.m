//
//  LZLockGuard.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/11.
//

#import "LZLockGuard.h"
#import "LZLock.h"

@interface LZLockGuard ()
@property (nonatomic, weak) LZLock *lock;
@end

@implementation LZLockGuard

- (void)dealloc {
    [self.lock unLock];
}

- (instancetype)initWithLock:(LZLock *)lock {
    if (self = [super init]) {
        self.lock = lock;
        [self.lock lock];
    }
    return self;
}

@end
