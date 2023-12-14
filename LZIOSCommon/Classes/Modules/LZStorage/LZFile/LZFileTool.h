//
//  LZFileTool.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import <Foundation/Foundation.h>
#import "LZSingleton.h"

NS_ASSUME_NONNULL_BEGIN

/*
 - Document
    - 此文件夹是默认备份的,备份到iCloud
    - 大文件要做 非备份设置(如视频) 审核的时候会被拒
    -  关键数据
        - 用户创建的数据，或者不能重新生成的数据
        - 应该存放在<Application_Home>/Documents目录下，并且不应该标记为"do not backup"属性
        - 关键数据在低存储空间时也会保留，而且会被iCloud或iTunes备份
    - 经常存储的一些东西
        - APP的数据库表
        - 必要的一些图标本地缓存
        - 重要的plist文件,如当前登录人的信息
 - Library
    - Caches
        - 系统的缓存都放在这个文件夹下面(主要是网路).
        - Snapshots默认文件夹
    - Preferences
        - iCloud进行备份
        - NSUserDefaults就是默认存放在此文件夹下面
 - Tmp
    - 临时文件夹(系统会不定期删除里面的文件)
 */
typedef enum : int {
    LZSandBoxTypeRoot = 0,
    LZSandBoxTypeDocument,
    LZSandBoxTypeLibrary,
    LZSandBoxTypeLibraryCaches,
    LZSandBoxTypeLibraryPreferecens,
    LZSandBoxTypeTmp,
} LZSandBoxType;

@interface LZFileTool : NSObject
LZSingletonH

+ (NSString *)sandBoxPath:(LZSandBoxType)type;

+ (BOOL)fileExist:(NSString *)path;

+ (BOOL)createFile:(NSString *)path error:(NSError **)error;

+ (BOOL)createDir:(NSString *)path error:(NSError **)error;

+ (BOOL)removePath:(NSString *)path error:(NSError **)error;

+ (nullable NSString *)refreshSandBoxPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
