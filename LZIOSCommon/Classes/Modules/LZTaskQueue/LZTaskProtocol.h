//
//  LZTaskProtocol.h
//  AMMobileFoundation-AMSecurityPolicy
//
//  Created by 金胜利 on 2023/9/19.
//

#import <Foundation/Foundation.h>
#import "LZCacheElementProtocol.h"

NS_ASSUME_NONNULL_BEGIN

// task
@class LZTask;
typedef void (^LZTaskCompletion) (LZTask *task, id _Nullable result, NSError * _Nullable error);
typedef void (^LZTaskProgress)   (LZTask *task, float progress);

// executer
typedef void (^LZTaskExecuterCompletion) (id _Nullable result, NSError * _Nullable error);
typedef void (^LZTaskExecuterProgress)   (float progress);

@protocol LZTaskExecuterProtocol <NSObject, LZCacheElementProtocol>

- (void)execute:(id)source
       progress:(nullable LZTaskExecuterProgress)progress
     completion:(nullable LZTaskExecuterCompletion)completion;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
