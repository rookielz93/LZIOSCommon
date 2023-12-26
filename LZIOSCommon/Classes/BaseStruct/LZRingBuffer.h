//
//  LZRingBuffer.h
//  LZIOSCommon
//
//  Created by 金胜利 on 2023/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZRingBuffer : NSObject

@property (nonatomic, readonly, assign) int capacity;     
@property (nonatomic, readonly, assign) int availableLen;

- (LZRingBuffer *)initWithCapacity:(int)capacity;

- (void)reset;

/// @return 真实写入数据的长度，空间不够直接返回0
- (int)write:(uint8_t *)data len:(int)len;

/// @return 真实读取数据的长度，数据不够，就返回差值
- (int)read:(uint8_t *)data len:(int)len;

@end

NS_ASSUME_NONNULL_END
