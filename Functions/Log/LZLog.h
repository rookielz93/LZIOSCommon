//
//  LZLog.h
//  PDDMediaCore
//
//  Created by jinshengli on 2023/1/17.
//

#import <Foundation/Foundation.h>

#ifndef __LZLog__
#define __LZLog__

#ifdef __FILE_NAME__
#define __FILENAME__ __FILE_NAME__
#else
#define __FILENAME__ (strrchr(__FILE__,'/')+1)
#endif
#define _LZModuleName @"LZ"
#define _LZLogPrefixFunc(modu, file, line, func) ([NSString stringWithFormat:@"[%@][%s:%d],%s", (modu), (file), (line), (func)])
#define _LZLogPrefix _LZLogPrefixFunc((_LZModuleName), __FILENAME__, __LINE__, __FUNCTION__)

/// 打印LZ-当前文件名-方法-行数
#define LZLoggerBaseInfo [LZLogger log:_LZLogPrefix level:(LZLoggerLevelInfo) format:nil]
/// 日志打印
#define LZLoggerBase(lev, form, ...) [LZLogger log:_LZModuleName file:__FILENAME__ func:__FUNCTION__ line:__LINE__ level:(lev) format:(form), ##__VA_ARGS__];
#define LZLoggerDebug(format, ...) LZLoggerBase(LZLoggerLevelDebug, format, ##__VA_ARGS__)
#define LZLoggerInfo(format, ...)  LZLoggerBase(LZLoggerLevelInfo, format, ##__VA_ARGS__)
#define LZLoggerError(format, ...) LZLoggerBase(LZLoggerLevelError, format, ##__VA_ARGS__)

typedef enum : int {
    LZLoggerLevelInfo,
    LZLoggerLevelDebug,
    LZLoggerLevelError
} LZLoggerLevel;

@interface LZLogger : NSObject

+ (void)log:(NSString *)moduleName
       file:(const char *)file func:(const char *)func line:(int)line
      level:(LZLoggerLevel)level
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(6,7);

+ (void)log:(NSString *)prefix level:(LZLoggerLevel)level format:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4);

@end

#endif

