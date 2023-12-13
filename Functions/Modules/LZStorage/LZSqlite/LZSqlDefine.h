//
//  LZSqlDefine.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/14.
//

#import <Foundation/Foundation.h>
#import "LZStringMacro.h"

// default primary define
#define LZSqlDefaultPrimaryKeyMacro         lz_primary
#define LZSqlDefaultPrimaryPropertyDefine   NSString *LZSqlDefaultPrimaryKeyMacro;
#define LZSqlDefaultPrimaryKey              LZObjcStringize(LZSqlDefaultPrimaryKeyMacro)
#define LZSqlIsDefaultPrimaryKey(s)         [(s) isEqualToString:LZSqlDefaultPrimaryKey]

// creat date
#define LZSqlCreateDateKeyMacro         lz_createDate
#define LZSqlCreateDatePropertyDefine   NSString *LZSqlCreateDateKeyMacro;
#define LZSqlCreateDateKey              LZObjcStringize(LZSqlCreateDateKeyMacro)
#define LZSqlIsCreateDateKey(s)         [(s) isEqualToString:LZSqlCreateDateKey]

// last update date
#define LZSqlLastUpdateDateKeyMacro         lz_lastUpdateDate
#define LZSqlLastUpdateDatePropertyDefine   NSString *LZSqlLastUpdateDateKeyMacro;
#define LZSqlLastUpdateDateKey              LZObjcStringize(LZSqlLastUpdateDateKeyMacro)
#define LZSqlIsLastUpdateDateKey(s)         [(s) isEqualToString:LZSqlLastUpdateDateKey]

// last update timestamp
#define LZSqlLastUpdateDateTimestampKeyMacro         lz_lastUpdateTimestamp
#define LZSqlLastUpdateDateTimestampPropertyDefine   NSString *LZSqlLastUpdateDateTimestampKeyMacro;
#define LZSqlLastUpdateDateTimestampKey              LZObjcStringize(LZSqlLastUpdateDateTimestampKeyMacro)
#define LZSqlIsLastUpdateDateTimestampKey(s)         [(s) isEqualToString:LZSqlLastUpdateDateTimestampKey]

typedef NS_ENUM(NSInteger, LZSqlConditionType) {
    LZSqlConditionType_And,
    LZSqlConditionType_Or,
};

typedef NS_ENUM(NSInteger, LZSqlConditionOperator) {
    LZSqlConditionOperator_Equal,
    LZSqlConditionOperator_NotEqual,
    LZSqlConditionOperator_Like,
    LZSqlConditionOperator_GreaterThan,
    LZSqlConditionOperator_GreaterThanOrEqual,
    LZSqlConditionOperator_LessThan,
    LZSqlConditionOperator_LessThanOrEqual,
};

typedef NS_ENUM(int, LZSqlChainType) {
    LZSqlChainTypeNone = 0,
    LZSqlChainTypeInsert,
    LZSqlChainTypeUpdate,
    LZSqlChainTypeRemove,
    LZSqlChainTypeRemoveAll,
    LZSqlChainTypeSelect,
    LZSqlChainTypeSelectAll,
//    LZSqlChainTypeSelectCount,
//    LZSqlChainTypeSelectCustomized,
    
    LZSqlChainTypeCreateTable = 100,
    LZSqlChainTypeDropTable,
    LZSqlChainTypeUpdateTable,
    LZSqlChainTypeTableExists,
    LZSqlChainTypeTableColumnNames,
//    LZSqlChainTypeTruncateTable,
};

typedef enum : int {
    LZSqlCMDTypeInvalid,
    LZSqlCMDTypeUpdate,
    LZSqlCMDTypeSelect,
    LZSqlCMDTypeSelectColumnNames,
    LZSqlCMDTypeTableExists,
} LZSqlCMDType;

typedef NS_ENUM(int, LZSqlRetDataType) {
    LZSqlRetDataTypeUnsupport = -1,
    LZSqlRetDataTypeInt = 0,
    LZSqlRetDataTypeUnsignedInt,
    LZSqlRetDataTypeLong,
    LZSqlRetDataTypeLongLong,
    LZSqlRetDataTypeUnsignedLong,
    LZSqlRetDataTypeUnsignedLongLong,
    LZSqlRetDataTypeDouble,
    LZSqlRetDataTypeFloat,
    LZSqlRetDataTypeString,
    
    LZSqlRetDataTypeNSNumber,
    LZSqlRetDataTypeNSData,
    LZSqlRetDataTypeNSDate
};

NS_ASSUME_NONNULL_BEGIN

@interface LZSqlDefine : NSObject

+ (NSString *)descForChainType:(LZSqlChainType)type;
+ (NSString *)descForConditionType:(LZSqlConditionType)type;
+ (NSString *)descForConditionOperator:(LZSqlConditionOperator)type;
+ (NSString *)descForSqlCMD:(LZSqlCMDType)type;

@end

NS_ASSUME_NONNULL_END
