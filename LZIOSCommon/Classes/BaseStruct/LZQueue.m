//
//  LZQueue.m
//  Almighty-Almighty
//
//  Created by jinshengli on 2023/1/12.
//

#import "LZQueue.h"

@interface LZQueue ()
{
    NSMutableArray *_cache;
}
@end

@implementation LZQueue

- (int)count { return (int)_cache.count; }

// FIXME: 用数组性能不是太好，后面考虑优化下
- (void)enqueue:(id)data {
    if (!data) return;
    if (!_cache) _cache = [NSMutableArray array];
    
    [_cache addObject:data];
}

- (id)dequeue {
    if (!_cache) return nil;
    if (_cache.count == 0) return nil;
    
    id firstData = _cache.firstObject;
    [_cache removeObject:firstData];
    return firstData;
}

- (NSArray *)datas { return [_cache copy]; }

- (void)removeAll { [_cache removeAllObjects]; }

- (void)remove:(id)data {
    if (!data) return;
    [_cache removeObject:data];
}

- (id)first {
    if (!_cache) return nil;
    return _cache.firstObject;
}

- (id)last {
    if (!_cache) return nil;
    return _cache.lastObject;;
}

@end

