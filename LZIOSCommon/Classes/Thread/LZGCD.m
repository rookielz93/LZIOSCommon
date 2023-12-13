//
//  LZGCD.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/11.
//

#import "LZGCD.h"

@interface LZGCD ()
{
    NSString *_name;
    
    dispatch_queue_t _queue;
    BOOL _judge;
}
@end

@implementation LZGCD

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name autoJudgeSameQueue:NO];
}

- (instancetype)initWithName:(NSString *)name autoJudgeSameQueue:(BOOL)autoJudge {
    if (self = [super init]) {
        _name = name.copy;
        _queue = dispatch_queue_create(_name.UTF8String, NULL);
        dispatch_queue_set_specific(_queue, &_name, (__bridge void *)_name, NULL);
        _judge = autoJudge;
    }
    return self;
}

- (void)async:(dispatch_block_t)action { dispatch_async(_queue, action); }

- (void)sync:(dispatch_block_t)action {
    if (_judge && [self isCurrentQueue]) {
        if (action) action();
    } else {
        dispatch_sync(_queue, action);
    }
}

- (void)after:(NSTimeInterval)delayInSeconds action:(dispatch_block_t)action {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), _queue, action);
}

// MARK: - Props

- (NSString *)description { return _name; }

- (BOOL)isCurrentQueue {
    return (dispatch_get_specific(&_name) == (__bridge void *)_name);
}

@end
