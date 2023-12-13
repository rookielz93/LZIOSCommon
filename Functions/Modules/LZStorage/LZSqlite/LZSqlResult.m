//
//  LZSqlResult.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/14.
//

#import "LZSqlResult.h"

@implementation LZSqlResult

+ (instancetype)failed {
    LZSqlResult *ret = [LZSqlResult new];
    ret.success = NO;
    ret.result = nil;
    return ret;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"suc: %d, ret: %@", self.success, self.result];
}

@end
