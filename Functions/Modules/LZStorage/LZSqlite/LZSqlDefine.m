//
//  LZSqlDefine.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/14.
//

#import "LZSqlDefine.h"

@implementation LZSqlDefine
//LZSqlChainTypeNone = 0,
//LZSqlChainTypeInsert,
//LZSqlChainTypeUpdate,
//LZSqlChainTypeRemove,
//LZSqlChainTypeRemoveAll,
//LZSqlChainTypeSelect,
//LZSqlChainTypeSelectCount,
//LZSqlChainTypeSelectCustomized,
//
//LZSqlChainTypeCreateTable,
//LZSqlChainTypeUpdateTable,
//LZSqlChainTypeDropTable,
//LZSqlChainTypeTruncateTable,
+ (NSString *)descForChainType:(LZSqlChainType)type {
    switch (type) {
        case LZSqlChainTypeCreateTable: return @"create table";
        case LZSqlChainTypeDropTable: return @"drop table";
        case LZSqlChainTypeUpdateTable: return @"update table";
        case LZSqlChainTypeTableColumnNames: return @"column names";
        case LZSqlChainTypeTableExists: return @"table exists";
            
        case LZSqlChainTypeInsert: return @"insert";
        case LZSqlChainTypeUpdate: return @"update";
        case LZSqlChainTypeRemove: return @"delete";
        case LZSqlChainTypeRemoveAll: return @"remove all";
        case LZSqlChainTypeSelect: return @"select";
        case LZSqlChainTypeSelectAll: return @"select all";
        default: return nil;
    }
}

+ (NSString *)descForConditionType:(LZSqlConditionType)type {
    switch (type) {
        case LZSqlConditionType_And: return @"and";
        case LZSqlConditionType_Or: return @"or";
        default: return nil;
    }
}

+ (NSString *)descForConditionOperator:(LZSqlConditionOperator)type {
    switch (type) {
        case LZSqlConditionOperator_LessThan: return @"<";
        case LZSqlConditionOperator_LessThanOrEqual: return @"<=";
        case LZSqlConditionOperator_GreaterThan: return @">";
        case LZSqlConditionOperator_GreaterThanOrEqual: return @">=";
        case LZSqlConditionOperator_Like: return @"like";
        case LZSqlConditionOperator_NotEqual: return @"<>";
        case LZSqlConditionOperator_Equal: return @"=";
        default: return nil;
    }
}

+ (NSString *)descForSqlCMD:(LZSqlCMDType)type {
    switch (type) {
        case LZSqlCMDTypeInvalid: return @"invalid";
        case LZSqlCMDTypeUpdate: return @"update";
        case LZSqlCMDTypeSelect: return @"select";
        case LZSqlCMDTypeSelectColumnNames: return @"select column names";
        case LZSqlCMDTypeTableExists: return @"table exists";
        default: return nil;
    }
}

@end
