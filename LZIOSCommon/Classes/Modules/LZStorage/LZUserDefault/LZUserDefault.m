//
//  LZUserDefault.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import "LZUserDefault.h"

@implementation LZUserDefault

+ (void)saveValue:(id)value key:(NSString *)key {
    if (!key) return;
    
    NSUserDefaults *defalults = [NSUserDefaults standardUserDefaults];
    id oldValue = [self getValueWithKey:key];
    if (oldValue && [oldValue isEqual:value]) {
        return;
    }
    [defalults setObject:value forKey:key];
    [defalults synchronize];
}

+ (void)saveBool:(BOOL)value forKey:(NSString *)key {
    if (!key) return;
    
    NSUserDefaults *defalults = [NSUserDefaults standardUserDefaults];
    [defalults setBool:value forKey:key];
    [defalults synchronize];
}

+ (id)getValueWithKey:(NSString *)key {
    if (!key) return nil;

    NSUserDefaults *defalults = [NSUserDefaults standardUserDefaults];
    return [defalults objectForKey:key];
}

+ (BOOL)getBoolWithKey:(NSString *)key {
    if (!key) return NO;
    
    NSUserDefaults *defalults = [NSUserDefaults standardUserDefaults];
    return [defalults boolForKey:key];
}

+ (void)removeValueForKey:(NSString *)key {
    if (!key) return;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
