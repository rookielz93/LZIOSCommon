//
//  LZSyncQueue.m
//  LZIOSCommon
//
//  Created by 金胜利 on 2023/12/29.
//

#import "LZSyncQueue.h"
#import "LZLog.h"
#import "LZCond.h"
#import "LZLock.h"
#import "LZLockGuard.h"
#import "LZQueue.h"

@interface LZSyncQueue ()

@property (nonatomic, assign) BOOL abort;
@property (nonatomic, strong) LZQueue *queue;
@property (nonatomic, strong) LZLock *lock;
@property (nonatomic, strong) LZCond *procuderCond;
@property (nonatomic, strong) LZCond *consumerCond;

@end

@implementation LZSyncQueue

// MARK: - Public

- (instancetype)initWithCapacity:(int)capacity {
    if (self = [super init]) {
        _capacity = capacity;
        _queue = [LZQueue new];
        _lock = [LZLock new];
        _procuderCond = [LZCond new];
        _consumerCond = [LZCond new];
    }
    return self;
}

- (void)start {
    __unused LZLockGuard *guard = [[LZLockGuard alloc] initWithLock:self.lock];
    self.abort = NO;
}

- (void)stop {
    __unused LZLockGuard *guard = [[LZLockGuard alloc] initWithLock:self.lock];
    self.abort = YES;
}

- (int)count {
    __unused LZLockGuard *guard = [[LZLockGuard alloc] initWithLock:self.lock];
    return self.queue.count;
}

- (BOOL)enqueue:(id)data error:(NSError **)error {
    if (!data) {
        return NO;
    }
    
    __unused LZLockGuard *guard = [[LZLockGuard alloc] initWithLock:self.lock];
    while (!self.abort) {
        if (self.queue.count < self.capacity) {
            [self.queue enqueue:data];
            [self.consumerCond signal];
            break;
        } else {
            [self.procuderCond wait:self.lock];
        }
    }
    return !self.abort;
}

- (BOOL)dequeue:(id _Nullable *_Nullable)data error:(NSError **)error {
    if (!data) {
        return NO;
    }
    
    __unused LZLockGuard *guard = [[LZLockGuard alloc] initWithLock:self.lock];
    while (!self.abort) {
        if (self.queue.count > 0) {
            *data = [self.queue dequeue];
            [self.procuderCond signal];
            break;
        } else {
            [self.consumerCond wait:self.lock];
        }
    }
    return !self.abort;
}

@end
