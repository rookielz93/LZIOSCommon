//
//  LZTaskConfig.m
//  LZ-kit
//
//  Created by 金胜利 on 2023/9/19.
//

#import "LZTaskConfig.h"

@implementation LZTaskConfig

- (instancetype)initWithSource:(id)source
                       excuter:(id<LZTaskExecuterProtocol>)executer
            executerCompletion:(LZTaskCompletion)completion  {
    if (self = [super init]) {
        self.source = source;
        self.executer = executer;
        self.completion = completion;
    }
    return self;
}

- (void)reset {
    self.source = nil;
    self.executer = nil;
    self.completion = nil;
}

@end
