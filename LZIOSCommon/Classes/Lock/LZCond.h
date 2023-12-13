//
//  LZCond.h
//  PDDMediaCoreExtend
//
//  Created by jinshengli on 2023/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LZLock;
@interface LZCond : NSObject

- (void)reset;

- (void)signal;

- (void)wait;

- (void)wait:(LZLock *)lock;

@end

NS_ASSUME_NONNULL_END
