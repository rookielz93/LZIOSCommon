//
//  NSObject+LZSql.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/13.
//

#import "NSObject+LZSql.h"
#import "LZSqlResult.h"
#import "LZSqlTool.h"

@implementation NSObject (LZSql)

+ (NSArray *)lz_queryAll {
    return LZSqlSelectAll(self).Execute.result;
}

+ (BOOL)lz_removeAll {
    return LZSqlRemoveAll(self).Execute.success;
}

+ (BOOL)lz_updateTable {
    return LZSqlUpdateTable(self).Execute.success;
}

- (BOOL)lz_save {
    LZSqlResult *ret = LZSqlUpdate(self).Execute;
    return ret.success;
}

- (BOOL)lz_remove {
    LZSqlResult *ret = LZSqlRemove(self).Execute;
    return ret.success;
}

+ (NSString *)lz_sqlTypeWithEncoding:(const char *)encoding {
    NSString *encode = [NSString stringWithUTF8String:encoding];
    if (   strcmp(encoding, @encode(int)) == 0
        || strcmp(encoding, @encode(unsigned int)) == 0
        || strcmp(encoding, @encode(long)) == 0
        || strcmp(encoding, @encode(unsigned long)) == 0
        || strcmp(encoding, @encode(BOOL)) == 0
        ) {
        return @"integer";
    }
    if (   strcmp(encoding, @encode(float)) == 0
        || strcmp(encoding, @encode(double)) == 0) {
        return @"real";
    }
    
    Class clazz = [self _GetClassFromEncode:encode];
    if (clazz) {
        if ([clazz isSubclassOfClass:[NSString class]]) return @"text";
        if ([clazz isSubclassOfClass:[NSNumber class]]) return @"real";
        if ([clazz isSubclassOfClass:[NSData class]])   return @"blob";
        if ([clazz isSubclassOfClass:[NSDate class]])   return @"timstamp";
    }
    return nil;
}

+ (LZSqlRetDataType)lz_sqlRetDataTypeWithEncoding:(const char *)encoding {
    NSString *encode = [NSString stringWithUTF8String:encoding];
    if (   strcmp(encoding, @encode(int)) == 0
        || strcmp(encoding, @encode(BOOL)) == 0) {
        return LZSqlRetDataTypeInt;
    }
    if (strcmp(encoding, @encode(unsigned int)) == 0) {
        return LZSqlRetDataTypeUnsignedInt;
    }
    if (strcmp(encoding, @encode(long)) == 0) {
        return LZSqlRetDataTypeLong;
    }
    if (strcmp(encoding, @encode(unsigned long)) == 0){
        return LZSqlRetDataTypeUnsignedLong;
    }
    if (strcmp(encoding, @encode(float)) == 0) {
        return LZSqlRetDataTypeFloat;
    }
    if (strcmp(encoding, @encode(double)) == 0) {
        return LZSqlRetDataTypeDouble;
    }
    
    Class clazz = [self _GetClassFromEncode:encode];
    if (clazz && [clazz isSubclassOfClass:[NSString class]]) {
        return LZSqlRetDataTypeString;
    }
    if (clazz && [clazz isSubclassOfClass:[NSNumber class]]) {
        return LZSqlRetDataTypeNSNumber;
    }
    if (clazz && [clazz isSubclassOfClass:[NSData class]]) {
        return LZSqlRetDataTypeNSData;
    }
    if (clazz && [clazz isSubclassOfClass:[NSDate class]]) {
        return LZSqlRetDataTypeNSDate;
    }
    
    return LZSqlRetDataTypeUnsupport;

}

// MARK: - Priv

static NSRegularExpression *_reg;
+ (Class)_GetClassFromEncode:(NSString *)encode {
    if (!_reg) {
        NSError *error;
        _reg = [[NSRegularExpression alloc] initWithPattern:@"\\b\\w+\\b" options:NSRegularExpressionCaseInsensitive error:&error];
    }
    NSArray<NSTextCheckingResult *> *arr = [_reg matchesInString:encode options:NSMatchingReportProgress range:NSMakeRange(0, encode.length)];
    if (arr.count) {
        return NSClassFromString([encode substringWithRange:arr.firstObject.range]);
    }
    return nil;
}

@end

#import "NSObject+LZRuntime.h"
#import "LZObjcProperty.h"

static const char *kLZPrimaryProperty = "lz_primary";
@implementation NSObject (LZSqlModel)

// MARK: - LZSqlModelProtocol

- (void)setLz_primary:(NSString *)lz_primary {
    objc_setAssociatedObject(self, kLZPrimaryProperty, lz_primary, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)lz_primary {
    return objc_getAssociatedObject(self, kLZPrimaryProperty);
}

+ (NSString *)lz_sqlName { return @"lz.sqlite"; }

+ (NSString *)lz_tableName { return [self lz_className]; }

+ (NSArray <NSString *>*)lz_excludePropertyNames { return nil; }

+ (NSArray <LZObjcProperty *>*)lz_registeredProperties {
    NSArray <LZObjcProperty *> *properties = [[self class] lz_objcProperties];
    NSArray *excludeNames = [[self class] lz_excludePropertyNames];
    NSMutableArray *tmp = @[].mutableCopy;
    for (LZObjcProperty *property in properties) {
        if ([excludeNames containsObject:property.name]) continue;
        if (!property.ivarName.length) continue; // 排除 只有属性，没有变量（比如：NSObject的hash，description等）
        [tmp addObject:property];
    }
    properties = tmp;
    return properties;
}

@end
