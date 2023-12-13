//
//  LZTask.m
//  AMMobileFoundation-AMSecurityPolicy
//
//  Created by 金胜利 on 2023/9/19.
//

#import "LZTask.h"
#import "LZTask+Internal.h"
#import "LZTaskConfig.h"
#import "LZLog.h"
#import "LZError.h"

@interface LZTask ()

@property (nonatomic, strong) LZTaskConfig *config;
@property (nonatomic, copy)   LZTaskProgress progress;
@property (nonatomic, copy)   LZTaskCompletion completion;

@end

@implementation LZTask

- (void)cancel {
    [self.config.executer cancel]; // MARK: executer 需要在cancel后回调，否则会有问题
}

@end

@implementation LZTask (Internal)

- (instancetype)initWithConfig:(LZTaskConfig *)config progress:(LZTaskProgress)progress completion:(LZTaskCompletion)completion {
    if (self = [super init]) {
        _config = config;
        self.progress = progress;
        self.completion = completion;
    }
    return self;
}

- (void)start {
    [self.config.executer execute:self.config.source progress:^(float progress) {
        if (self.progress) {
            self.progress(self, progress);
        }
    } completion:^(id result, NSError *error) {
        self->_result = result;
        self->_error = error;
        if (self.completion) {
            self.completion(self, result, error);
        }
        [self _reset];
    }];
}

- (void)_reset {
    self.completion = nil;
    self.progress = nil;
}

@end
