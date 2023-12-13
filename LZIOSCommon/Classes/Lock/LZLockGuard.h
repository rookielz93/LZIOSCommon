//
//  LZLockGuard.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LZLock;
@interface LZLockGuard : NSObject

- (instancetype)initWithLock:(LZLock *)lock;

@end

NS_ASSUME_NONNULL_END
