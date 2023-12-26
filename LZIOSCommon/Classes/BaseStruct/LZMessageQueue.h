//
//  LZMessageQueue.h
//  LZIOSCommon
//
//  Created by 金胜利 on 2023/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZMessage : NSObject

@property (nonatomic, assign) int what;
@property (nonatomic, strong) id args;

@end

@interface LZMessageQueue : NSObject

@property (nonatomic, readonly, assign) int count;
@property (nonatomic, readonly, assign) BOOL isEmpty;

- (void)start;

- (void)stop;

- (void)put:(LZMessage *)msg error:(NSError **)error;

- (void)put:(int)what args:(id)args error:(NSError **)error;

- (LZMessage *)get:(NSError **)error; // default block
- (LZMessage *)get:(BOOL)block error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
