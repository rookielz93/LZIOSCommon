//
//  LZGCD.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZGCD : NSObject

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name autoJudgeSameQueue:(BOOL)autoJudge; // default no judge

- (void)async:(dispatch_block_t)action;

- (void)sync:(dispatch_block_t)action;

- (void)after:(NSTimeInterval)delayInSeconds action:(dispatch_block_t)action;

- (BOOL)isCurrentQueue;

@end

NS_ASSUME_NONNULL_END
