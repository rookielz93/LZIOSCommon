//
//  LZSqlTool.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import <Foundation/Foundation.h>
#import "LZSingleton.h"
#import "LZSqlChain.h"
#import "LZSqlCondition.h"

/*
 参考：
 https://zhang759740844.github.io/2017/11/30/FMDB/ // sql语句
 https://github.com/scubers/JRDB#queryId // 封装库
 https://www.jianshu.com/p/54b38b28defb  // 升级
 */

NS_ASSUME_NONNULL_BEGIN

/// Helper
#define LZSqlCreateTable(_cls_)     LZSqlChain.CreateTable([_cls_ class])
#define LZSqlCreateTable2(_cls_)    LZSqlChain.CreateTable(_cls_)
#define LZSqlDropTable(_cls_)       LZSqlChain.DropTable([_cls_ class])
#define LZSqlDropTable2(_cls_)      LZSqlChain.DropTable(_cls_)
#define LZSqlUpdateTable(_cls_)     LZSqlChain.UpdateTable([_cls_ class])
#define LZSqlUpdateTable2(_cls_)    LZSqlChain.UpdateTable(_cls_)
#define LZSqlTableExists(_cls_)     LZSqlChain.TableExists([_cls_ class])
#define LZSqlTableExists2(_cls_)    LZSqlChain.TableExists(_cls_)
#define LZSqlTableColumns(_cls_)    LZSqlChain.TableColumnNames([_cls_ class])
#define LZSqlTableColumns2(_cls_)   LZSqlChain.TableColumnNames(_cls_)
#define LZSqlInsert(...)            LZSqlChain.Insert(LZVarListToArray(__VA_ARGS__, 0))
#define LZSqlRemove(...)            LZSqlChain.Remove(LZVarListToArray(__VA_ARGS__, 0))
#define LZSqlRemoveAll(_cls_)       LZSqlChain.RemoveAll([_cls_ class])
#define LZSqlUpdate(...)            LZSqlChain.Update(LZVarListToArray(__VA_ARGS__, 0))
#define LZSqlSelect(_cls_)          LZSqlChain.Select([_cls_ class])
#define LZSqlSelectAll(_cls_)       LZSqlChain.SelectAll([_cls_ class])
static inline NSArray * _Nullable LZVarListToArray(id _Nullable first, ...) {
    if (!first) return nil;
    
    NSMutableArray *args = @[].mutableCopy;
    [args addObject:first];
    va_list valist;
    va_start(valist, first);
    id arg;
    while( (arg = va_arg(valist,id)) ) {
        if (arg) [args addObject:arg];
    }
    return args;
}

@class LZSqlResult;
@interface LZSqlTool : NSObject
LZSingletonH

@property (nonatomic, strong) NSString *defaultSqlName;

- (LZSqlResult *)executeChain:(LZSqlChain *)chain;

@end

NS_ASSUME_NONNULL_END
