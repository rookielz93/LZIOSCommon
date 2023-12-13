//
//  NSObject+LZSql.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/13.
//

#import <Foundation/Foundation.h>
#import "LZSqlModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LZSql)

+ (NSArray *)lz_queryAll;
+ (BOOL)lz_removeAll;
+ (BOOL)lz_updateTable;

- (BOOL)lz_save;

- (BOOL)lz_remove;

+ (NSString *)lz_sqlTypeWithEncoding:(const char *)encoding;
+ (LZSqlRetDataType)lz_sqlRetDataTypeWithEncoding:(const char *)encoding;

@end

@interface NSObject (LZSqlModel) <LZSqlModelProtocol>

@property (nonatomic, strong) LZSqlDefaultPrimaryPropertyDefine;

@end

NS_ASSUME_NONNULL_END
