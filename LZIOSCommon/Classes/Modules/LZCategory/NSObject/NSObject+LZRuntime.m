//
//  NSObject+LZRuntime.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import "NSObject+LZRuntime.h"
#import <objc/runtime.h>
#import "LZObjcProperty.h"

@implementation NSObject (LZRuntime)

+ (NSString *)lz_className { return NSStringFromClass(self); }

+ (NSString *)lz_shortClassName {
    NSString *name = [self lz_className];
    if ([name rangeOfString:@"."].length) {
        name = [name substringFromIndex:[name rangeOfString:@"."].location + 1];
    }
    return name;
}

+ (NSArray *)lz_propertyNames {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *ret = @[].mutableCopy;
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        if (name.length) {
            [ret addObject:name];
        }
    }
    free(properties);
    return ret;
}

+ (NSArray<LZObjcProperty *> *)lz_objcProperties {
    unsigned int count = 0;
    objc_property_t *props = class_copyPropertyList([self class], &count);
    NSMutableArray *ret = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        [ret addObject:[LZObjcProperty prop:props[i]]];
    }
    free(props);
    return ret.copy;
}

- (NSString *)lz_uuid {
    return @(self.hash).stringValue;
}

- (NSDictionary<NSString *, id> *)lz_2Dict {
    NSArray<LZObjcProperty *> *props = [[self class] lz_objcProperties];
    NSMutableDictionary *dict = @[].mutableCopy;
    [props enumerateObjectsUsingBlock:^(LZObjcProperty *obj, NSUInteger idx, BOOL *stop) {
        id value = [self valueForKey:obj.name];
        dict[obj.name] = value ?: [NSNull null];
    }];
    return [dict copy];
}

@end
