//
//  FMResultSet+Parser.m
//  VideoDownloader
//
//  Created by lz on 2023/9/16.
//

#import "FMResultSet+Parser.h"
#import <objc/runtime.h>
#import "FMResultSet.h"
#import "NSObject+LZSql.h"
#import "LZObjcProperty.h"
#import "LZSqlChain.h"
#import "LZLog.h"

@implementation FMResultSet (Parser)

- (NSArray *)parseWithChain:(LZSqlChain *)chain {
    NSArray *ret = nil;
    Class<LZSqlModelProtocol> clazz = chain.targetClazz;
    if (chain.type == LZSqlChainTypeTableColumnNames) {
        ret = [self _parseToColumnNames];
    } else if (chain.type == LZSqlChainTypeTableExists) {
        ret = [self _parseToTableNames:chain];
    } else if (clazz) {
        ret = [self _parseToObjects:clazz];
    } else {
        LZLoggerError(@"unknown chain result parse");
    }
    return ret;
}

// MARK: - Priv

// 解析成对象
- (NSArray *)_parseToObjects:(Class<LZSqlModelProtocol>)clazz {
    NSMutableArray *ret = @[].mutableCopy;
    
    NSArray<LZObjcProperty *> *properties = [clazz lz_registeredProperties];
    Class cls = objc_getClass(class_getName(clazz));
    
    while ([self next]) {
        NSObject<LZSqlModelProtocol> *obj = [[cls alloc] init];
        
        NSString *primary = [self stringForColumn:LZSqlDefaultPrimaryKey];
        obj.lz_primary = primary;
        
        for (LZObjcProperty *property in properties) {
            if (LZSqlIsDefaultPrimaryKey(property.ivarName)) continue;
        
            LZSqlRetDataType type = [NSObject lz_sqlRetDataTypeWithEncoding:property.typeEncoding.UTF8String];
            NSString *name = property.name;
            switch (type) {
                case LZSqlRetDataTypeNSData: {
                    id value = [self dataForColumn:name];
                    [obj setValue:value forKey:name];
                    break;
                }
                case LZSqlRetDataTypeString: {
                    id value = [self stringForColumn:name];
                    [obj setValue:value forKey:name];
                    break;
                }
                case LZSqlRetDataTypeNSNumber: {
                    id value = [NSNumber numberWithDouble:[self doubleForColumn:name]];
                    [obj setValue:value forKey:name];
                    break;
                }
                case LZSqlRetDataTypeInt: {
                    int temp = [self intForColumn:name];
                    [obj setValue:@(temp) forKey:name];
                    break;
                }
                case LZSqlRetDataTypeUnsignedInt: {
                    unsigned long long temp = [self unsignedLongLongIntForColumn:name];
                    [obj setValue:@(temp) forKey:name];
                    break;
                }
                case LZSqlRetDataTypeLong: {
                    long temp = [self longForColumn:name];
                    [obj setValue:@(temp) forKey:name];
                    break;
                }
                case LZSqlRetDataTypeLongLong: {
                    long long temp = [self longLongIntForColumn:name];
                    [obj setValue:@(temp) forKey:name];
                    break;
                }
                case LZSqlRetDataTypeUnsignedLong: {
                    unsigned long long temp = [self unsignedLongLongIntForColumn:name];
                    [obj setValue:@(temp) forKey:name];
                    break;
                }
                case LZSqlRetDataTypeUnsignedLongLong:{
                    unsigned long long temp = [self unsignedLongLongIntForColumn:name];
                    [obj setValue:@(temp) forKey:name];
                    break;
                }
                case LZSqlRetDataTypeDouble: {
                    double temp = [self doubleForColumn:name];
                    [obj setValue:@(temp) forKey:name];
                    break;
                }
                case LZSqlRetDataTypeFloat: {
                    float temp = [self doubleForColumn:name];
                    [obj setValue:@(temp) forKey:name];
                    break;
                }
                case LZSqlRetDataTypeNSDate:{
                    NSDate *date = [self dateForColumn:name];
                    [obj setValue:date forKey:name];
                    break;
                }
                case LZSqlRetDataTypeUnsupport:
                default:
                    break;
            }
        }
        
        [ret addObject:obj];
    }
    [self close];
    
    return ret;
}

// 其它：如:表列名
- (NSArray *)_parseToColumnNames {
    NSMutableArray *ret = @[].mutableCopy;
    while ([self next]) {
        NSString *columnName = [self stringForColumn:@"name"];
        [ret addObject:columnName];
        LZLoggerInfo(@"%@", self.columnNameToIndexMap);
    }
    [self close];
    return ret;
}

- (NSArray *)_parseToTableNames:(LZSqlChain *)chain {
    NSMutableArray *ret = @[].mutableCopy;
    while ([self next]) {
        int count = [self intForColumn:@"count"];
        if (count != 0) {
            [ret addObject:[chain.targetClazz lz_tableName]];
            break;
        }
    }
    [self close];
    return ret;
}

//- (NSArray<NSString *> *)getAllColumnsFromTable:(NSString *)tableName dataBase:(FMDatabase *)dataBase isIncludingPrimaryKey:(BOOL)isIncluding {
//    NSMutableArray *columns = [NSMutableArray array];
//
//    FMResultSet *resultSet = [dataBase getTableSchema:tableName];
//    while ([resultSet next]) {
//        NSString *columnName = [resultSet stringForColumn:@"name"];
//        if ([columnName isEqualToString:yii_primary_key] && !isIncluding) {
//            continue;
//        }
//        [columns addObject:columnName];
//    }
//
//    return columns;
//}

@end
