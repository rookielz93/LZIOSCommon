//
//  LZCookieManager.h
//  TestProject
//
//  Created by 金胜利 on 2023/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WKNavigationResponse;
@class WKHTTPCookieStore;
@interface LZCookieManager : NSObject

+ (void)clearCookieForKey:(NSString *)key;

+ (void)saveCookies:(NSArray <NSHTTPCookie *>*)cookies forKey:(NSString *)key;
+ (void)saveCookieWithStore:(WKHTTPCookieStore *)store forKey:(NSString *)key;
+ (void)saveCookieWithResponse:(WKNavigationResponse *)navigationResponse forKey:(NSString *)key;
+ (NSArray <NSHTTPCookie *>*)getCookieWithKey:(NSString *)key;
+ (NSArray <NSDictionary *>*)getCookieDictWithKey:(NSString *)key;
+ (NSString *)getCookieStringWithKey:(NSString *)key;

+ (void)updateForHTTPCookie:(NSArray <NSDictionary *>*)cookies;
+ (void)logHTTPCookie;

@end

NS_ASSUME_NONNULL_END
