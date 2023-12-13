//
//  LZSqlChainParser.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/14.
//

#import "LZSqlChainParser.h"
#import "LZSqlChain.h"
#import "LZSqlCondition.h"
#import "LZSqlDefine.h"
#import "NSObject+LZRuntime.h"
#import "NSObject+LZSql.h"
#import "LZObjcProperty.h"
#import "LZSqlResult.h"
#import "LZSqlTool.h"
#import "LZTool.h"
#import "LZLog.h"

@implementation LZSqlCMD
- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@, %@", [LZSqlDefine descForSqlCMD:self.type], self.cmd, self.args];
}
@end

@implementation LZSqlChainParser

+ (LZSqlCMD *)_tableExists:(LZSqlChain *)chain {
    LZSqlCMD *cmd = [LZSqlCMD new];
    cmd.type = LZSqlCMDTypeSelect;
    cmd.cmd = @"select count(*) as 'count' from sqlite_master where type = 'table' and name = ?;";
    cmd.args = @[ [chain.targetClazz lz_tableName] ];
    return cmd;
}

/*
 @"create table if not exists student (
     id integer PRIMARY KEY AUTOINCREMENT,
     name text,
     age integer NOT NULL,
     sex text NOT NULL);"
 */
+ (LZSqlCMD *)_createTable:(LZSqlChain *)chain {
    LZSqlCMD *ret = [LZSqlCMD new];
    
    NSMutableString *keyCMD = [NSMutableString stringWithFormat:@"%@ text primary key, %@ timestamp not null default current_timestamp", LZSqlDefaultPrimaryKey, LZSqlLastUpdateDateKey];
    Class<LZSqlModelProtocol> clazz = chain.targetClazz;
    NSArray<LZObjcProperty *> *properties = [clazz lz_registeredProperties];
    for (LZObjcProperty *property in properties) {
        if (LZSqlIsDefaultPrimaryKey(property.name)) continue;

        NSString *typeDesc = [NSObject lz_sqlTypeWithEncoding:property.typeEncoding.UTF8String];
        if (typeDesc) {
            [keyCMD appendString:@", "];
            [keyCMD appendFormat:@"%@ %@", property.name, typeDesc];
        } else {
            LZLoggerInfo(@"%@'type desc is nil", property.name);
        }
    }

    ret.type = LZSqlCMDTypeUpdate;
    ret.cmd = [NSString stringWithFormat:@"create table if not exists %@ (%@);", [clazz lz_tableName], keyCMD];
    return ret;
}

/*
 更新表结构，目前是只增不减column
 alter table t_student
 add name text, add title text,
 drop column vend_num;
 */
+ (LZSqlCMD *)_updateTable:(LZSqlChain *)chain {
    LZSqlCMD *ret = [LZSqlCMD new];
    
    Class<LZSqlModelProtocol> clazz = chain.targetClazz;
    
    BOOL tableExists = LZSqlTableExists(clazz).Execute.success;
    if (tableExists) {
        NSArray *oldColumnNames = LZSqlTableColumns(clazz).Execute.result;
    
        NSMutableString *keyCMD = @"".mutableCopy;
        NSArray<LZObjcProperty *> *properties = [clazz lz_registeredProperties];
        for (LZObjcProperty *property in properties) {
            if (![oldColumnNames containsObject:property.name]) {
                NSString *typeDesc = [NSObject lz_sqlTypeWithEncoding:property.typeEncoding.UTF8String];
                if (!typeDesc) {
                    LZLoggerInfo(@"%@'type desc is nil", property.name);
                    continue;
                }
                
                if (keyCMD.length > 0) {
                    [keyCMD appendString:@", "];
                }
                [keyCMD appendFormat:@"add %@ %@", property.name, typeDesc];
            }
        }
        
        if (keyCMD.length == 0) {
            ret.type = LZSqlCMDTypeInvalid;
        } else {
            ret.type = LZSqlCMDTypeUpdate;
            ret.cmd = [NSString stringWithFormat:@"alter table %@ %@;", [clazz lz_tableName], keyCMD];
        }
    } else {
        ret = [self _createTable:chain];
    }
    return ret;
}

// 删除整个表，不留痕迹
+ (LZSqlCMD *)_dropTable:(LZSqlChain *)chain {
    LZSqlCMD *ret = [LZSqlCMD new];
    ret.type = LZSqlCMDTypeUpdate;
    ret.cmd = [NSString stringWithFormat:@"drop table %@;", [chain.targetClazz lz_tableName]];
    return ret;
}

// 获取所有的column names
+ (LZSqlCMD *)_tableColumnNames:(LZSqlChain *)chain {
    LZSqlCMD *ret = [LZSqlCMD new];
    ret.type = LZSqlCMDTypeSelectColumnNames;
    return ret;
}

/*
 插入或更新
 insert or replace into t_status (id, status) values (1,'aa');
 insert or replace into t_status (id, status) values (1,'aa',1001), (2,'bb',1001);
 
 执行这条语句会有一定的限制条件
 1、就是SQL语句中必须要包含主键，就是说我们插入的时候一定要写上主键
 2、就是主键不能是自动增长的，因为主键的数值需要我们去指定
 如果我们指定的主键不存在的话，就是去新增记录
 如果我们指定的主键存在的话，就是去修改记录
 
 正常的插入
 @"insert into t_status (id, status) values (?,?)", 1, "aa"
 */
+ (LZSqlCMD *)_insertOrUpdate:(LZSqlChain *)chain {
    LZSqlCMD *ret = [LZSqlCMD new];
    
    NSMutableString *keyCMD = [NSMutableString stringWithFormat:@"%@,", LZSqlDefaultPrimaryKey];
    NSMutableString *valueCMD = @"?,".mutableCopy;
    NSMutableString *valuesCMD = @"".mutableCopy;
    NSMutableArray *args = @[].mutableCopy;
    
    Class<LZSqlModelProtocol> targetClazz = chain.targetClazz;
    NSArray<LZObjcProperty *> *properties = [targetClazz lz_registeredProperties];

    // key value cmd
    for (int i=0; i<properties.count; i++) {
        LZObjcProperty *property = properties[i];
        NSString *typeDesc = [NSObject lz_sqlTypeWithEncoding:property.typeEncoding.UTF8String];
        if (typeDesc) {
            [keyCMD appendString:property.name];
            [valueCMD appendString:@"?"];
            if (i != properties.count-1) {
                [keyCMD appendString:@","];
                [valueCMD appendString:@","];
            }
        }
    }
    
    // args
    for (int i=0; i<chain.targets.count; i++) {
        NSObject<LZSqlModelProtocol> *target = chain.targets[i];
        // primary set
        NSString *primary = [target lz_primary];
        if (!primary) {
            primary = [LZTool uuid];
            target.lz_primary = primary;
        }
        [args addObject:primary];
        // args
        for (int j=0; j<properties.count; j++) {
            LZObjcProperty *property = properties[j];
            NSString *typeDesc = [NSObject lz_sqlTypeWithEncoding:property.typeEncoding.UTF8String];
            if (typeDesc) {
                id value = [target valueForKey:property.name];
                [args addObject:value ?: [NSNull null]];
            }
        }
        // values cmd
        [valuesCMD appendFormat:@"(%@)", valueCMD];
        if (i != chain.targets.count-1) {
            [valuesCMD appendString:@", "];
        }
    }

    ret.type = LZSqlCMDTypeUpdate;
    ret.cmd = [NSString stringWithFormat:@"insert or replace into %@ (%@) values %@;",
               [targetClazz lz_tableName], keyCMD, valuesCMD];
    ret.args = args;
    return ret;
}

/*
    @"delete from t_student where id = ?;"
    @"delete from t_student where (id = 1 or id = 2);"
    @"delete from t_student where id in (1, 2);"
    @"delete from t_student where id in (?, ?);" args
 */
+ (LZSqlCMD *)_remove:(LZSqlChain *)chain {
    LZSqlCMD *ret = [LZSqlCMD new];
    
    NSMutableString *valuesCMD = @"".mutableCopy;
    NSMutableArray *args = @[].mutableCopy;
    for (int i=0; i<chain.targets.count; i++) {
        NSObject<LZSqlModelProtocol> *target = chain.targets[i];
        // values cmd
        // check primary
        NSString *primary = [target lz_primary];
        if (!primary) {
            LZLoggerError(@"primary is nil");
            continue;
        }
        if (valuesCMD.length != 0) {
            [valuesCMD appendString:@","];
        }
        [valuesCMD appendString:@"?"];
        
        // args
        [args addObject:primary];
    }
    
    if (args.count == 0) {
        LZLoggerError(@"failed to remove(%@), because primary is nil", chain);
        return nil;
    }
    
    Class<LZSqlModelProtocol> targetClazz = chain.targetClazz;
    ret.type = LZSqlCMDTypeUpdate;
    ret.cmd = [NSString stringWithFormat:@"delete from %@ where %@ in (%@);",
               [targetClazz lz_tableName], LZSqlDefaultPrimaryKey, valuesCMD];
    ret.args = args;
    return ret;
}

// 删除所有数据，但保留表结构
+ (LZSqlCMD *)_removeAll:(LZSqlChain *)chain {
    LZSqlCMD *ret = [LZSqlCMD new];
    ret.type = LZSqlCMDTypeUpdate;
    ret.cmd = [NSString stringWithFormat:@"truncate table %@;", [chain.targetClazz lz_tableName]];
    return ret;
}

/*
 TODO: select single/multi
 @"select id, name, age from t_student order by column1, column2, ... asc|desc";
 */
+ (LZSqlCMD *)_select:(LZSqlChain *)chain {
    LZSqlCMD *ret = [LZSqlCMD new];
    ret.type = LZSqlCMDTypeSelect;
    return ret;
}

+ (LZSqlCMD *)_selectAll:(LZSqlChain *)chain {
    LZSqlCMD *ret = [LZSqlCMD new];
    ret.type = LZSqlCMDTypeSelect;
    ret.cmd = [NSString stringWithFormat:@"select * from %@ order by %@ desc;", [chain.targetClazz lz_tableName], LZSqlLastUpdateDateKey];
    return ret;
}

+ (LZSqlCMD *)parse:(LZSqlChain *)chain {
    if (!chain) {
        LZLoggerError(@"chain is nil, return nil");
        return nil;
    }
    
    LZLoggerInfo(@"start parse: %@", chain);
    
    LZSqlCMD *cmd = nil;
    switch (chain.type) {
        case LZSqlChainTypeCreateTable:
        {
            cmd = [self _createTable:chain];
        } break;
        case LZSqlChainTypeDropTable:
        {
            cmd = [self _dropTable:chain];
        } break;
        case LZSqlChainTypeUpdateTable:
        {
            cmd = [self _updateTable:chain];
        } break;
        case LZSqlChainTypeTableExists:
        {
            cmd = [self _tableExists:chain];
        } break;
        case LZSqlChainTypeTableColumnNames:
        {
            cmd = [self _tableColumnNames:chain];
        } break;
        case LZSqlChainTypeInsert:
        case LZSqlChainTypeUpdate:
        {
            cmd = [self _insertOrUpdate:chain];
        } break;
        case LZSqlChainTypeRemove:
        {
            cmd = [self _remove:chain];
        } break;
        case LZSqlChainTypeRemoveAll: // truncate
        {
            cmd = [self _removeAll:chain];
        } break;
        case LZSqlChainTypeSelect:
        {
            cmd = [self _select:chain];
        } break;
        case LZSqlChainTypeSelectAll:
        {
            cmd = [self _selectAll:chain];
        } break;
        default: cmd = nil; break;
    }
    
    LZLoggerInfo(@"finish parsed: %@", cmd);
    return cmd;
}

@end
