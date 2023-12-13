//
//  LZQueue.h
//  Almighty-Almighty
//
//  Created by jinshengli on 2023/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZQueue : NSObject

- (int)count;
- (void)enqueue:(id)data;
- (id)dequeue;
- (void)removeAll;
- (void)remove:(id)data;

- (NSArray *)datas;
- (id)first;
- (id)last;

@end

NS_ASSUME_NONNULL_END
