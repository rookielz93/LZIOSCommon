//
//  LZError.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString*const LZErrorKey;
extern LZErrorKey LZErrorKeyCustomCode;

typedef enum : int {
    LZErrorCodeUnknown = -1,
    LZErrorCodeCustom
} LZErrorCode;

#define LZErrorDomainFromInstance (NSStringFromClass(self.class))
#define LZErrorDomainFromClass (NSStringFromClass(self))

#define LZErrorResult2(domain, code) LZErrorResult3(domain, code, 0)
#define LZErrorResult3(lzDomain, lzCode, lzCustomCode) [LZError domain:lzDomain code:lzCode customCode:lzCustomCode]

@interface LZError : NSError

+ (instancetype)domain:(NSString *)domain code:(int)code customCode:(int)customCode;

+ (NSString *)descForCode:(LZErrorCode)code;

@end

NS_ASSUME_NONNULL_END
