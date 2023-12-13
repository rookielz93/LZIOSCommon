//
//  LZLog.m
//  PDDMediaCore
//
//  Created by jinshengli on 2023/1/17.
//

#import "LZLog.h"

@implementation LZLogger

#define _LZLogPrefixLevelFunc(prefix, level) ([NSString stringWithFormat:@"%@[%@]", (prefix), [self _levelDes:(level)]])
#define _LZLoggerFormatProcess if (format) { \
                                    if ([format isKindOfClass:NSString.class]) { \
                                        va_list args; \
                                        va_start(args, format); \
                                        NSString *printStr = [[NSString alloc] initWithFormat:format arguments:args]; \
                                        va_end(args); \
                                        result = [NSString stringWithFormat:@"%@: %@", result, printStr]; \
                                    } else { \
                                        [self _logError]; \
                                    } \
                                }

+ (void)log:(NSString *)moduleName
       file:(const char *)file func:(const char *)func line:(int)line
      level:(LZLoggerLevel)level
     format:(NSString *)format, ... {
    NSString *result = _LZLogPrefixFunc(moduleName, file, line, func);
    result = _LZLogPrefixLevelFunc(result, level);
    _LZLoggerFormatProcess
    [self _log:result level:level];
}

+ (void)log:(NSString *)prefix level:(LZLoggerLevel)level format:(NSString *)format, ... {
    NSString *result = _LZLogPrefixLevelFunc(prefix, level);
    _LZLoggerFormatProcess
    [self _log:result level:level];
}

// MARK: - Private

+ (NSString *)_levelDes:(LZLoggerLevel)level {
    switch (level) {
        case LZLoggerLevelDebug:
            return @"D";
        case LZLoggerLevelInfo:
            return @"I";
        case LZLoggerLevelError:
            return @"E";
    }
}

+ (void)_log:(NSString *)log level:(LZLoggerLevel)level {
//    if (LZLoggerLevelDebug == level) return;
    NSLog(@"%@", log);
}

+ (void)_logError {
    NSLog(@"输入参数异常");
}

@end
