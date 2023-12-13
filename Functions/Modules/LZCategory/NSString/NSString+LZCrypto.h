//
//  NSString+LZCrypto.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LZCrypto)

- (NSString *)toMD5;

- (NSString *)uniqueFileName;

- (NSString *)uniqueFileNameFromBase;

@end

NS_ASSUME_NONNULL_END
