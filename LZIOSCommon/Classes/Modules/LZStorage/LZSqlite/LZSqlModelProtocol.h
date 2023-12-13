//
//  LZSqlModelProtocol.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/14.
//

#import <Foundation/Foundation.h>
#import "LZSqlDefine.h"

NS_ASSUME_NONNULL_BEGIN

@class LZObjcProperty;
@protocol LZSqlModelProtocol <NSObject>

@property (nonatomic, strong) LZSqlDefaultPrimaryPropertyDefine;

+ (NSString *)lz_sqlName;
+ (NSString *)lz_tableName;
+ (NSArray <NSString *>*)lz_excludePropertyNames;
+ (NSArray <LZObjcProperty *>*)lz_registeredProperties;

@end

NS_ASSUME_NONNULL_END
