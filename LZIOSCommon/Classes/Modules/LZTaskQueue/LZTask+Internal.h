//
//  LZTask+Internal.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/20.
//

#import "LZTask.h"
#import "LZTaskProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class LZTaskConfig;
@interface LZTask (Internal)

@property (nonatomic, strong) LZTaskConfig *config;

- (instancetype)initWithConfig:(LZTaskConfig *)config progress:(LZTaskProgress)progress completion:(LZTaskCompletion)completion;

- (void)start;  // 内部使用，由queue主动调用，外部不要使用

@end

NS_ASSUME_NONNULL_END
