//
//  NSObject+LZRuntime.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LZObjcProperty;
@interface NSObject (LZRuntime)

+ (NSString *)lz_className;

+ (NSString *)lz_shortClassName;

+ (NSArray *)lz_propertyNames;

+ (NSArray<LZObjcProperty *> *)lz_objcProperties;

- (NSString *)lz_uuid;

- (NSDictionary<NSString *, id> *)lz_2Dict;

@end

NS_ASSUME_NONNULL_END
