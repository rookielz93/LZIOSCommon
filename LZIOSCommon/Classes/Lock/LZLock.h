//
//  LZLock.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZLock : NSObject

- (void)lock;
- (void)unLock;

@end

NS_ASSUME_NONNULL_END
