//
//  LZQueue.h
//  Almighty-Almighty
//
//  Created by jinshengli on 2023/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZQueue : NSObject

@property (nonatomic, readonly, assign) int count;
@property (nonatomic, readonly, assign) BOOL isEmpty;

- (void)enqueue:(id)data;
- (id)dequeue;

- (void)reset;

- (NSArray *)peekAll;
- (id)peekFront;
- (id)peekLast;

@end

NS_ASSUME_NONNULL_END
