//
//  LZFDDefine.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : int {
    LZFDStatusDownloading,
    LZFDStatusDownloaded,
    LZFDStatusCancelled
} LZFDStatus;

@interface LZFDDefine : NSObject

+ (NSString *)descForFDStatus:(LZFDStatus)status;

@end

NS_ASSUME_NONNULL_END
