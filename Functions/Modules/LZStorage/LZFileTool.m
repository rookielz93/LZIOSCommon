//
//  LZFileTool.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import "LZFileTool.h"
#import "LZLog.h"

#define LZFilePathValid(path) ((path) && [(path) isKindOfClass:NSString.class] && (path).length>0)
#define LZFilePathCheckRetNO(path) if ( ! LZFilePathValid((path)) ) return NO;
#define LZFilePathCheckRetNIL(path) if ( ! LZFilePathValid((path)) ) return nil;

@interface LZFileTool ()
@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation LZFileTool
LZSingletonM

- (void)_setup {
    _fileManager = [NSFileManager defaultManager];
}

+ (NSFileManager *)fileManager { return [[self sharedInstance] fileManager]; }

// MARK: - Public

+ (NSString *)sandBoxPath:(LZSandBoxType)type {
    NSSearchPathDirectory dt;
    switch (type) {
        case LZSandBoxTypeDocument:
            dt = NSDocumentDirectory;
            break;
        case LZSandBoxTypeLibrary:
            dt = NSLibraryDirectory;
            break;
        case LZSandBoxTypeLibraryCaches:
            dt = NSCachesDirectory;
            break;
        case LZSandBoxTypeLibraryPreferecens:
            dt = NSPreferencePanesDirectory;
            break;
        case LZSandBoxTypeRoot: return NSHomeDirectory();
        case LZSandBoxTypeTmp: return NSTemporaryDirectory();
        default:
            break;
    }
    return NSSearchPathForDirectoriesInDomains(dt, NSUserDomainMask, YES).firstObject;
}

+ (BOOL)fileExist:(NSString *)path {
    LZFilePathCheckRetNO(path)
    return [self.fileManager fileExistsAtPath:path];
}

+ (BOOL)removePath:(NSString *)path error:(NSError **)error {
    LZFilePathCheckRetNO(path)
    return [self.fileManager removeItemAtPath:path error:error];
}

+ (BOOL)createFile:(NSString *)path error:(NSError **)error {
    LZFilePathCheckRetNO(path)
    return [self.fileManager createFileAtPath:path contents:nil attributes:nil];
}

+ (BOOL)createDir:(NSString *)path error:(NSError **)error {
    LZFilePathCheckRetNO(path)
    BOOL isDir = NO;
    BOOL exists = [self.fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (exists || !isDir) {
        return [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+ (NSString *)refreshSandBoxPath:(NSString *)path {
    LZFilePathCheckRetNIL(path);
    
    NSString *root = [self sandBoxPath:LZSandBoxTypeRoot];
    if ([path containsString:root]) {
        return path;
    }
    
    NSString *post = root.lastPathComponent;
    NSString *pre = [root substringToIndex:[root rangeOfString:post].location-1];
    NSArray *components = [path componentsSeparatedByString:@"/"];
    NSMutableString *ret = @"".mutableCopy;
    
    BOOL replaced = NO;
    for (NSString *component in components) {
        if (component.length > 0) {
            if ([ret containsString:pre] && !replaced) {
                [ret appendFormat:@"/%@", post];
                replaced = YES;
            } else {
                [ret appendFormat:@"/%@", component];
            }
        }
    }
    return ret;
}

@end
