//
//  LZInPurchaseTaskWrapper.m
//  VideoDownloader
//
//  Created by lz on 2023/9/23.
//

#import "LZInPurchaseTaskWrapper.h"

@implementation LZInPurchaseTaskWrapper

- (instancetype)initWithTask:(id)task completion:(id)completion {
    if (self = [super init]) {
        self.task = task;
        self.completion = completion;
    }
    return self;
}

@end
