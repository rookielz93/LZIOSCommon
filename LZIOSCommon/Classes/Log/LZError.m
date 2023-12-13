//
//  LZError.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/18.
//

#import "LZError.h"

/// LZErrorKey
LZErrorKey LZErrorKeyCustomCode = @"custom_code";

@implementation LZError

+ (instancetype)domain:(NSString *)domain code:(int)code customCode:(int)customCode {
    return [self errorWithDomain:domain code:code userInfo:@{
        LZErrorKeyCustomCode : @(customCode),
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%@, sys_code: %d", [self descForCode:code], customCode]
    }];
}

+ (NSString *)descForCode:(LZErrorCode)code {
    switch (code) {
        case LZErrorCodeUnknown: return @"unknown";
        case LZErrorCodeCustom: return @"custom";
        default: return nil;
    }
}

@end
