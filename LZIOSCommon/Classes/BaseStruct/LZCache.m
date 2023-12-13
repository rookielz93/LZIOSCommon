//
//  LZCache.m
//  AMMobileFoundation-AMSecurityPolicy
//
//  Created by 金胜利 on 2023/9/19.
//

#import "LZCache.h"

@interface LZCache ()

@property (nonatomic, strong) Class<LZCacheElementProtocol> elementCls;
@property (nonatomic, strong) id arg;
@property (nonatomic, assign) int maxCount;

@property (nonatomic, strong) NSMutableArray *idleElements;
@property (nonatomic, strong) NSMutableArray *usedElements;

@end

@implementation LZCache

- (instancetype)initWithElementCls:(Class<LZCacheElementProtocol>)elementCls arg:(id)arg {
    return [self initWithElementCls:elementCls arg:arg maxCount:INT_MAX];
}

- (instancetype)initWithElementCls:(Class<LZCacheElementProtocol>)elementCls arg:(id)arg maxCount:(int)maxCount {
    if (self = [super init]) {
        self.elementCls = elementCls;
        self.arg = arg;
        self.maxCount = maxCount;
    }
    return self;
}

- (void)destroy {
    [_idleElements removeAllObjects];
    [_usedElements removeAllObjects];
}

- (id)getIdleElement {
    id ret = nil;
    if (self.idleElements.count > 0) {
        ret = self.idleElements.lastObject;
        [self.idleElements removeLastObject];
    } else if (self.usedElements.count < self.maxCount) {
        ret = [self _genElement];
    }
    
    if (ret) {
        [self.usedElements addObject:ret];
    }
    return ret;
}

- (void)giveback:(id)element {
    if (!element || ![element isKindOfClass:self.elementCls]) return;
    
    [self.usedElements removeObject:element];
    [self.idleElements addObject:element];
}

// MARK: - Priv

- (id)_genElement {
    return [[self.elementCls.class alloc] initWithArg:self.arg];
}

// MARK: - Props

- (NSMutableArray<NSMutableData *> *)idleElements {
    if (!_idleElements) _idleElements = [NSMutableArray array];
    return _idleElements;
}

- (NSMutableArray<NSMutableData *> *)usedElements {
    if (!_usedElements) _usedElements = [NSMutableArray array];
    return _usedElements;
}

@end
