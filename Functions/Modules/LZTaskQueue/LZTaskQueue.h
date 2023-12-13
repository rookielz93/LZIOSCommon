//
//  LZTaskQueue.h
//  AMMobileFoundation-AMSecurityPolicy
//
//  Created by 金胜利 on 2023/9/19.
//

#import <Foundation/Foundation.h>
#import "LZTaskProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/*
 一般executer是异步任务比较适合LZTaskQueue，每个LZTask可以节省一个线程
 
 - LZTaskQueue
    - maxCount:     int // 最大并发个数
    - allTasks:     Array<LZTask *>
    - waitingTasks: LZQueue<LZTask *>
    - executers:    LZCache<id<LZTaskExecuterProtocol>> // 有容量的Cache
    
 - LZTask // 里面不会起线程，线程需要的话再executer里面自己创建
    - LZTaskConfig
        - source
        - executer: id<LZTaskExecuterProtocol>
        - Function:
            - execute: progress: completion:
            - cancel
    - result
    - error
 */

@class LZTask;
@interface LZTaskQueue : NSObject

- (instancetype)initWithExecuterCls:(Class<LZTaskExecuterProtocol>)excuterCls excuterArg:(nullable id)arg maxCount:(int)maxCount;

- (LZTask *)addTask:(id)source progress:(LZTaskProgress)progress completion:(LZTaskCompletion)completion;

- (void)cancelAll;

@end

NS_ASSUME_NONNULL_END
