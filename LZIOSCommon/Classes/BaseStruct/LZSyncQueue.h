//
//  LZSyncQueue.h
//  LZIOSCommon
//
//  Created by 金胜利 on 2023/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZSyncQueue : NSObject

@property (nonatomic, readonly, assign) int capacity;

- (instancetype)initWithCapacity:(int)capacity;

- (void)start;
- (void)stop;

- (int)count;

- (BOOL)enqueue:(id)data error:(NSError **)error;
- (BOOL)dequeue:(id _Nullable *_Nullable)data error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
