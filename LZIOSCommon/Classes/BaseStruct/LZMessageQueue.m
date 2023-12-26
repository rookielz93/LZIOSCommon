//
//  LZMessageQueue.m
//  LZIOSCommon
//
//  Created by 金胜利 on 2023/12/25.
//

#import "LZMessageQueue.h"
#import "LZQueue.h"
#import "LZCond.h"
#import "LZLock.h"
#import "LZLockGuard.h"
#import "LZError.h"
#import "LZLog.h"

@implementation LZMessage

@end

@interface LZMessageQueue ()

@property (nonatomic, strong) LZQueue *msgQueue;
@property (nonatomic, assign) BOOL abort;
@property (nonatomic, strong) LZCond *cond;
@property (nonatomic, strong) LZLock *lock;

@end

@implementation LZMessageQueue

- (instancetype)init {
    if (self = [super init]) {
        _msgQueue = [LZQueue new];
        _cond = [LZCond new];
        _lock = [LZLock new];
    }
    return self;
}

- (int)count {
    __unused LZLockGuard *guard = [[LZLockGuard alloc] initWithLock:self.lock];
    return self.msgQueue.count;
}

- (BOOL)isEmpty { return (self.count == 0); }

- (void)start {
    __unused LZLockGuard *guard = [[LZLockGuard alloc] initWithLock:self.lock];
    self.abort = NO;
    [self.cond reset];
    LZLoggerBaseInfo;
}

- (void)stop {
    __unused LZLockGuard *guard = [[LZLockGuard alloc] initWithLock:self.lock];
    self.abort = YES;
    [self.cond signal];
    LZLoggerBaseInfo;
}

- (void)put:(LZMessage *)msg error:(NSError **)error {
    __unused LZLockGuard *guard = [[LZLockGuard alloc] initWithLock:self.lock];
    if (self.abort) {
        LZLoggerError(@"message queue is abort, return");
        if (error) *error = LZErrorResult2(LZErrorDomainFromInstance, 0);
        return;
    }
    
    [self.msgQueue enqueue:msg];
    [self.cond signal];
}

- (void)put:(int)what args:(id)args error:(NSError **)error {
    LZMessage *msg = [LZMessage new];
    msg.what = what;
    msg.args = args;
    [self put:msg error:error];
}

- (LZMessage *)get:(NSError **)error {
    return [self get:YES error:error];
}

- (LZMessage *)get:(BOOL)block error:(NSError **)error {
    __unused LZLockGuard *guard = [[LZLockGuard alloc] initWithLock:self.lock];
    while (YES) {
        if (self.abort) {
            LZLoggerError(@"message queue is abort, return");
            if (error) *error = LZErrorResult2(LZErrorDomainFromInstance, 0);
            return nil;
        }
        
        LZMessage *msg = [self.msgQueue dequeue];
        if (msg == nil) {
            if (block) {
                [self.cond wait:self.lock];
            } else {
                return nil;
            }
        }
    }
}

@end
