//
//  LZTaskQueue.m
//  AMMobileFoundation-AMSecurityPolicy
//
//  Created by 金胜利 on 2023/9/19.
//

#import "LZTaskQueue.h"
#import "LZQueue.h"
#import "LZCache.h"
#import "LZGCD.h"
#import "LZTaskConfig.h"
#import "LZTask+Internal.h"

@interface LZTaskQueue ()

@property (nonatomic, strong) NSMutableArray <LZTask *>*tasks;  // [ LZTask ]
@property (nonatomic, strong) LZQueue *waitingTaskQueue;        // [ LZTask ]
@property (nonatomic, strong) LZCache *executerCache;           // [ Executer ]

@property (nonatomic, strong) LZGCD *safe;
@property (nonatomic, strong) LZGCD *cb;

@end

@interface LZTaskQueue (Internal)

- (LZTask *)_addTask:(id)source progress:(LZTaskProgress)progress completion:(LZTaskCompletion)completion;
- (void)_cancelAll;

@end

@implementation LZTaskQueue

- (instancetype)initWithExecuterCls:(Class<LZTaskExecuterProtocol>)excuterCls excuterArg:(id)arg maxCount:(int)maxCount {
    if (self = [super init]) {
        _tasks = @[].mutableCopy;
        _waitingTaskQueue = [LZQueue new];
        _executerCache = [[LZCache alloc] initWithElementCls:excuterCls arg:arg maxCount:maxCount];
        _safe = [[LZGCD alloc] initWithName:@"com.lz.task.safe.queue"];
        _cb = [[LZGCD alloc] initWithName:@"com.lz.task.cb.queue"];
    }
    return self;
}

- (LZTask *)addTask:(id)source progress:(LZTaskProgress)progress completion:(LZTaskCompletion)completion {
    __block LZTask *ret = nil;
    [self.safe sync:^{
        ret = [self _addTask:source progress:progress completion:completion];
    }];
    return ret;
}

- (void)cancelAll {
    [self.safe async:^{
        [self _cancelAll];
    }];
}

@end

@implementation LZTaskQueue (Internal)

- (LZTask *)_addTask:(id)source progress:(LZTaskProgress)progress completion:(LZTaskCompletion)completion {
    LZTaskConfig *config = [[LZTaskConfig alloc] initWithSource:source excuter:nil executerCompletion:completion];
    LZTask *task = [[LZTask alloc] initWithConfig:config progress:progress completion:^(LZTask *t, id result, NSError *error) {
        [self _taskCompleted:t];
    }];
    
    id<LZTaskExecuterProtocol> executer = [self.executerCache getIdleElement];
    if (executer) {
        config.executer = executer;
        [task start];
    } else {
        [self.waitingTaskQueue enqueue:task];
    }
    return task;
}

- (void)_cancelAll {
    for (LZTask *task in self.tasks) {
        [task cancel];
    }
    [self.tasks removeAllObjects];
    [self.waitingTaskQueue reset];
}

// MARK: - Helper

- (void)_taskCompleted:(LZTask *)task {
    [self.safe async:^{
        [self __taskCompleted:task];
    }];
}

- (void)__taskCompleted:(LZTask *)task {
    [self.executerCache giveback:task.config.executer];
    [self.tasks removeObject:task];
    [self _callback:task];
    
    // 如果还有任务需要执行，就按照顺序执行
    if (self.waitingTaskQueue.count > 0) {
        LZTask *task = self.waitingTaskQueue.dequeue;
        task.config.executer = [self.executerCache getIdleElement];
        [task start];
    }
}

- (void)_callback:(LZTask *)task {
    [self.cb async:^{
        if (task.config.completion) {
            task.config.completion(task, task.result, task.error);
            [task.config reset];
        }
    }];
}

@end
