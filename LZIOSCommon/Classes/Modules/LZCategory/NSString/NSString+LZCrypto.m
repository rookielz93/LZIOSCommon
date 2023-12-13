//
//  NSString+LZCrypto.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/18.
//

#import "NSString+LZCrypto.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSURL+LZCrypto.h"

@implementation NSString (LZCrypto)

- (NSString *)toMD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *resultStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return [resultStr lowercaseString];
}

- (NSString *)uniqueFileName {
    return [NSString stringWithFormat:@"%@.%@", self.toMD5, self.pathExtension];
}

- (NSString *)uniqueFileNameFromBase {
    return [[NSURL URLWithString:self] uniqueFileNameFromBase];
}

@end
