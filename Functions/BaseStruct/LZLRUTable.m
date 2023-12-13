//
//  LZLRUTable.m
//  TestProject
//
//  Created by 金胜利 on 2023/8/3.
//

#import "LZLRUTable.h"
#import "LZLog.h"

@interface LZLRUNode ()

@property (nonatomic, strong) LZLRUNode *pre;
@property (nonatomic, strong) LZLRUNode *next;

@end
@implementation LZLRUNode

- (instancetype)initWithKey:(NSString *)key value:(id)value {
    if (self = [super init]) {
        _key = key.copy;
        _value = value;
        _pre = nil;
        _next = nil;
    }
    return self;
}

@end

#define LZLRUT_CHECK_KEY_VALID(key) ((key) && [(key) isKindOfClass:NSString.class] && (key).length>0)
#define LZLRUT_CHECK_KEY_VALID_RET_NO(key)  if ( !LZLRUT_CHECK_KEY_VALID((key)) ) { \
                                                 LZLoggerInfo(@"key is in valid");   \
                                                 return NO;                           \
                                             }
#define LZLRUT_CHECK_KEY_VALID_RET_NIL(key) if ( !LZLRUT_CHECK_KEY_VALID((key)) ) { \
                                                 LZLoggerInfo(@"key is in valid");   \
                                                 return nil;                          \
                                             }

#define LZLRUT_CHECK_VALUE_VALID(value) ((value) != nil)
#define LZLRUT_CHECK_VALUE_VALID_RET_NO(value)  if ( !LZLRUT_CHECK_VALUE_VALID((value)) ) { \
                                                     LZLoggerInfo(@"value is in valid");     \
                                                     return NO;                               \
                                                 }
#define LZLRUT_CHECK_VALUE_VALID_RET_NIL(value) if ( !LZLRUT_CHECK_VALUE_VALID((value)) ) { \
                                                     LZLoggerInfo(@"value is in valid");     \
                                                     return nil;                              \
                                                 }

@interface LZLRUTable ()
{
    NSMutableDictionary <NSString *, LZLRUNode *>*_nodeMap;
    LZLRUNode *_head;
    LZLRUNode *_tail;
}
@end

@implementation LZLRUTable

- (instancetype)init {
   if (self = [super init]) {
       _nodeMap = @{}.mutableCopy;
       _head = nil;
       _tail = nil;
   }
   return self;
}

- (int)count { return (int)_nodeMap.count; }

- (BOOL)add:(id)value {
    LZLRUT_CHECK_VALUE_VALID_RET_NO(value)
    return [self add:value forKey:[self _autoGenKeyFor:value]];
}

- (LZLRUNode *)remove:(id)value {
    LZLRUT_CHECK_VALUE_VALID_RET_NIL(value)
    return [self removeValueForKey:[self _autoGenKeyFor:value]];
}

- (LZLRUNode *)getLRUNodeWithValue:(id)value {
    LZLRUT_CHECK_VALUE_VALID_RET_NIL(value)
    return [self getLRUNodeWithKey:[self _autoGenKeyFor:value]];
}

- (BOOL)add:(id)value forKey:(NSString *)key {
    LZLRUT_CHECK_KEY_VALID_RET_NO(key)
    LZLRUT_CHECK_VALUE_VALID_RET_NO(value)
    
    LZLRUNode *node = [self getLRUNodeWithKey:key];
    if (!node) {
        node = [self _createNodeWithKey:key value:value];
        if (_head) {
            node.next = _head;
            _head.pre = node;
            _head = node;
        } else {
            _head = node;
            _head.next = nil;
            _tail = node;
            _tail.next = nil;
        }
        _nodeMap[key] = node;
    }
    
    return YES;
}

- (LZLRUNode *)removeValueForKey:(NSString *)key {
    LZLRUT_CHECK_KEY_VALID_RET_NIL(key)
 
    LZLRUNode *node = _nodeMap[key];
    if (node) {
        [_nodeMap removeObjectForKey:key];
        if (node == _head) {
            _head = _head.next;
            _head.pre = nil;
        } else if (node == _tail) {
            node.pre.next = nil;
            _tail = node.pre;
        } else {
            node.pre.next = node.next;
            node.next.pre = node.pre;
        }
    }
    
    return node;
}

- (LZLRUNode *)getLRUNodeWithKey:(NSString *)key {
    LZLRUT_CHECK_KEY_VALID_RET_NIL(key)
    
    LZLRUNode *node = _nodeMap[key];
    if (node) {
        if (node == _head) {
            return node;
        }
        if (node == _tail) {
            node.pre.next = nil;
            _tail = node.pre;
        } else { // 将 node 从链表中摘出来
            node.pre.next = node.next;
            node.next.pre = node.pre;
        }
        
        // 放到head
        node.pre = nil;
        node.next = _head;
        _head.pre = node;
        _head = node;
    }
    
    return node;
}

- (LZLRUNode *)removeLast {
    LZLoggerBaseInfo;
    return [self removeValueForKey:_tail.key];
}

- (void)clear {
    LZLoggerBaseInfo;
    [_nodeMap removeAllObjects];
    _head = nil;
    _tail = nil;
}

// MARK: - Priv

- (NSString *)_autoGenKeyFor:(id)value {
    return [NSString stringWithFormat:@"%p", value];
}

- (LZLRUNode *)_createNodeWithKey:(NSString *)key value:(id)value {
    return [[LZLRUNode alloc] initWithKey:key value:value];
}

- (NSString *)description {
    if (_head == nil) return @"";
        
    NSMutableString *inOrderDes = [NSString stringWithFormat:@"(%d)-in_order", self.count].mutableCopy;
    LZLRUNode *node = _head;
    while (node) {
        [inOrderDes appendFormat:@"->(%@ : %@)", node.key, node.value];
//        [inOrderDes appendFormat:@"->(%@)", node.key];
        node = node.next;
    }
    
    NSMutableString *reversedOrderDes = [NSString stringWithFormat:@"(%d)-re_order", self.count].mutableCopy;
    node = _tail;
    while (node) {
        [reversedOrderDes appendFormat:@"->(%@ : %@)", node.key, node.value];
//        [reversedOrderDes appendFormat:@"->(%@)", node.key];
        node = node.pre;
    }
    
    return [NSString stringWithFormat:@"\n%@\n%@", inOrderDes, reversedOrderDes];
}

@end
