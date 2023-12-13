//
//  LZCache.h
//  AMMobileFoundation-AMSecurityPolicy
//
//  Created by 金胜利 on 2023/9/19.
//

#import <Foundation/Foundation.h>
#import "LZCacheElementProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZCache : NSObject

- (instancetype)initWithElementCls:(Class<LZCacheElementProtocol>)elementCls arg:(id)arg;
- (instancetype)initWithElementCls:(Class<LZCacheElementProtocol>)elementCls arg:(id)arg maxCount:(int)maxCount;

- (void)destroy;

- (id)getIdleElement;

- (void)giveback:(id)Element;

@end

NS_ASSUME_NONNULL_END
