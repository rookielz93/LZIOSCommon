//
//  LZUserDefault.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZUserDefault : NSObject

+ (void)saveValue:(id)value key:(NSString *)key;
+ (void)saveBool:(BOOL)value forKey:(NSString *)key;
+ (id)getValueWithKey:(NSString *)key;
+ (BOOL)getBoolWithKey:(NSString *)key;
+ (void)removeValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
