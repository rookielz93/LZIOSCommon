//
//  LZSqlTool.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import "LZSqlTool.h"
#import "FMDB.h"
#import "LZLog.h"
#import "LZGCD.h"
#import "LZFileTool.h"
#import "LZSqlChainParser.h"
#import "LZSqlResult.h"
#import "FMResultSet+Parser.h"

@interface LZSqlTable : NSObject
@property (nonatomic, strong) NSString *name;
@end
@implementation LZSqlTable
@end

@interface LZSqlDB : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSMutableDictionary <NSString*, LZSqlTable*>*tableMap; // { name : table }
@property (nonatomic, strong) NSMutableArray <LZSqlTable*>*tableList;
@end
@implementation LZSqlDB
- (NSMutableArray<LZSqlTable *> *)tableList {
    if (!_tableList) _tableList = @[].mutableCopy;
    return _tableList;
}
- (NSMutableDictionary<NSString *, LZSqlTable *>*)tableMap {
    if (!_tableMap) _tableMap = @{}.mutableCopy;
    return _tableMap;
}
@end

#define LZSqlCheckRetNO(what, arg)     if ( ! LZSql##what##Valid((arg)) ) return NO;
#define LZSqlCheckRetNil(what, arg)    if ( ! LZSql##what##Valid((arg)) ) return nil;
#define LZSqlCheckRetResult(what, arg) if ( ! LZSql##what##Valid((arg)) ) return [LZSqlResult failed];

#define LZSqlChainValid(arg) ((arg) != nil)
#define LZSqlChainCheckRetNO(arg)     LZSqlCheckRetNO(Chain, (arg))
#define LZSqlChainCheckRetNil(arg)    LZSqlCheckRetNil(Chain, (arg))
#define LZSqlChainCheckRetResult(arg) LZSqlCheckRetResult(Chain, (arg))

#define LZSqlNameValid(arg) ((arg) && [(arg) isKindOfClass:NSString.class] && (arg).length>0)
#define LZSqlNameCheckRetNO(arg)     LZSqlCheckRetNO(Name, (arg))
#define LZSqlNameCheckRetNil(arg)    LZSqlCheckRetNil(Name, (arg))
#define LZSqlNameCheckRetResult(arg) LZSqlCheckRetResult(Name, (arg))

@interface LZSqlTool ()

@property (nonatomic, readonly, strong) NSString *rootDir;
@property (nonatomic, strong) NSMutableDictionary<NSString*, LZSqlDB*> *dbs; // { name : db }
@property (nonatomic, strong) LZGCD *safe;

@end

@implementation LZSqlTool
LZSingletonM

// MARK: - Private

- (void)_setup {
    // root dir
    _rootDir = [[LZFileTool sandBoxPath:LZSandBoxTypeDocument] stringByAppendingPathComponent:@"LZDBRoot"];
    NSError *error = nil;
    if (![LZFileTool createDir:_rootDir error:&error]) {
        LZLoggerError(@"%@", error);
    }
    
    // db table
    _defaultSqlName = @"lz.sqlite";
    _dbs = @{}.mutableCopy;
    
    // safe
    _safe = [[LZGCD alloc] initWithName:@"com.lz.sql.safe" autoJudgeSameQueue:YES];
    LZLoggerInfo(@"%@", _rootDir);
}

- (BOOL)_fmdbExecuteUpdate:(LZSqlCMD *)cmd forSql:(LZSqlDB *)lzDB {
    __block BOOL ret = NO;
    [lzDB.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        ret = [db executeUpdate:cmd.cmd withArgumentsInArray:cmd.args];
        if (!ret) {
            LZLoggerError(@"sql(%@) fail to excute: %@", lzDB.name, cmd);
            return;
        }
        LZLoggerInfo(@"sql(%@) success to execute %@", lzDB.name, cmd);
    }];
    return ret;
}

- (FMResultSet *)_fmdbExecuteSelect:(LZSqlCMD *)cmd forSql:(LZSqlDB *)lzDB {
    __block FMResultSet *ret = nil;
    [lzDB.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        ret = [db executeQuery:cmd.cmd withArgumentsInArray:cmd.args];
        if (!ret) {
            LZLoggerError(@"sql(%@) fail to query: %@", lzDB.name, cmd.cmd);
            return;
        }
        LZLoggerInfo(@"sql(%@) success to query %@", lzDB.name, cmd);
    }];
    return ret;
}

- (FMResultSet *)_fmdbSelectAllColumns:(LZSqlChain *)chain forSql:(LZSqlDB *)lzDB {
    __block FMResultSet *ret = nil;
    [lzDB.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        ret = [db getTableSchema:[chain.targetClazz lz_tableName]];
    }];
    return ret;
}

- (LZSqlDB *)_loadSql:(NSString *)sqlName {
    LZSqlNameCheckRetNil(sqlName);
    
    LZSqlDB *lzDB = self.dbs[sqlName];
    if (lzDB) return lzDB;
    
    NSString *path = [_rootDir stringByAppendingPathComponent:sqlName];
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    lzDB = [LZSqlDB new];
    lzDB.name = sqlName;
    lzDB.path = path;
    lzDB.dbQueue = dbQueue;
    self.dbs[sqlName] = lzDB;
    LZLoggerInfo(@"create database(%@) success", sqlName);
    
    return lzDB;
}

- (LZSqlResult *)_execute:(LZSqlChain *)chain {
    LZSqlChainCheckRetResult(chain);
    
    NSString *sqlName = chain.sqlName ?: self.defaultSqlName;
    LZSqlChainCheckRetResult(sqlName);
    
    // load sql
    LZSqlDB *db = [self _loadSql:sqlName];
    
    // parse cmd
    LZSqlCMD *cmd = [LZSqlChainParser parse:chain];
    
    // execute
    LZSqlResult *ret = [LZSqlResult failed];
    switch (cmd.type) {
        case LZSqlCMDTypeInvalid:
        {
            ret.success = YES;
        }
            break;
        case LZSqlCMDTypeUpdate:
        {
            ret.success = [self _fmdbExecuteUpdate:cmd forSql:db];
        }
            break;
        case LZSqlCMDTypeSelect:
        {
            FMResultSet *set = [self _fmdbExecuteSelect:cmd forSql:db];
            ret.result = [set parseWithChain:chain];
            ret.success = (ret.result.count > 0);
            LZLoggerInfo(@"%@, %@", set, ret);
        }
            break;
        case LZSqlCMDTypeSelectColumnNames:
        {
            FMResultSet *set = [self _fmdbSelectAllColumns:chain forSql:db];
            ret.result = [set parseWithChain:chain];
            ret.success = (ret.result.count > 0);
            LZLoggerInfo(@"%@, %@", set, ret);
        }
            break;
        default:
            break;
    }
    return ret;
}

// MARK: - Public

- (void)setDefaultSqlName:(NSString *)defaultSqlName {
    [self.safe sync:^{
        self->_defaultSqlName = defaultSqlName;
    }];
}

- (LZSqlResult *)executeChain:(LZSqlChain *)chain {
    __block LZSqlResult *ret = nil;
    [self.safe sync:^{
        ret = [self _execute:chain];
    }];
    return ret;
}

- (void)_test {
    id<LZSqlModelProtocol>m;
    LZSqlChain.Insert(@[m]).And(@"name").eq(@"xiaohong");
    [[LZSqlTool sharedInstance] executeChain:LZSqlChain.Insert(@[m])];
    
}

@end
