//
//  LZCookieManager.m
//  TestProject
//
//  Created by 金胜利 on 2023/10/25.
//

#import "LZCookieManager.h"
#import <WebKit/WebKit.h>
#import "LZLog.h"

// https://www.jianshu.com/p/71a5c768d110
@implementation LZCookieManager

+ (void)clearCookieForKey:(NSString *)key {
    if (!key) {
        LZLoggerError(@"key is nil, return");
        return;
    }
    
    // delete http cookie // domain: .instagram.com
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    // delete file
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveCookieWithStore:(WKHTTPCookieStore *)store forKey:(NSString *)key {
    if (!store || !key) {
        LZLoggerError(@"store or key is nil, return");
        return;
    }
    
    [store getAllCookies:^(NSArray<NSHTTPCookie *> *cookies) {
        [self saveCookies:cookies forKey:key];
    }];
}

// MARK: 目前这个接口在 iOS 11 之后，貌似不起作用了，可以使用 saveCookieWithStore:forKey:
+ (void)saveCookieWithResponse:(WKNavigationResponse *)navigationResponse forKey:(NSString *)key {
    if (!navigationResponse || !key) {
        LZLoggerError(@"response or key is nil, return");
        return;
    }
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    [self saveCookies:cookies forKey:key];
    // 读取wkwebview中的cookie 方法2 读取Set-Cookie字段
    // NSString *cookieString = response.allHeaderFields[@"Set-Cookie"];
}

+ (void)saveCookies:(NSArray <NSHTTPCookie *>*)cookies forKey:(NSString *)key {
    
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    NSMutableArray *cookieArray = @[].mutableCopy;
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieArray addObject:cookie.properties];
    }

    [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray <NSDictionary *>*)getCookieDictWithKey:(NSString *)key {
    if (!key) {
        LZLoggerError(@"key is nil, return");
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (NSArray <NSHTTPCookie *>*)getCookieWithKey:(NSString *)key {
    if (!key) {
        LZLoggerError(@"key is nil, return");
        return nil;
    }
    
    NSArray <NSDictionary *>*cookieDict = [self getCookieDictWithKey:key];
    NSMutableArray *ret = @[].mutableCopy;
    for (NSDictionary *dict in cookieDict) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dict];
        [ret addObject:cookie];
    }
    return ret;
}

+ (NSString *)getCookieStringWithKey:(NSString *)key {
    NSArray <NSDictionary *>*cookies = [self getCookieDictWithKey:key];
    if (!cookies) {
        return nil;
    }
    
    NSMutableDictionary *deduplicatedCookies = @{}.mutableCopy;
    for (NSDictionary *cookie in cookies) {
        deduplicatedCookies[NSHTTPCookieName] = cookie[NSHTTPCookieValue];
    }

    NSMutableString *cookieString = @"".mutableCopy;
    for (NSString *key in deduplicatedCookies.allKeys) {
        [cookieString appendFormat:@"%@=%@;", key, deduplicatedCookies[key]];
    }
    return cookieString.copy;
}

+ (void)updateForHTTPCookie:(NSArray <NSDictionary *>*)cookies {
    if (!cookies || cookies.count==0) {
        LZLoggerError(@"cookies is nil, return");
        return;
    }
    
    for (NSDictionary *cookie in cookies) {
        NSHTTPCookie *httpCookie = [NSHTTPCookie cookieWithProperties:cookie];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:httpCookie];
    }
}

+ (void)logHTTPCookie {
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    LZLoggerInfo(@"http cookie count: %d", (int)cookies.cookies.count);
    for (NSHTTPCookie *cookie in cookies.cookies) {
        LZLoggerInfo(@"NSHTTPCookieStorage中的cookie: %@", cookie);
    }
}

@end
