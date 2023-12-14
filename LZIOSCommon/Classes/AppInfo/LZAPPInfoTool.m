//
//  LZAPPInfoTool.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import "LZAPPInfoTool.h"
#import "LZLog.h"

LZAppInfoKey LZAppInfoAppIdKey = @"LZAppInfoAppIdKey";
LZAppInfoKey LZAppInfoPrivacyURLKey = @"LZAppInfoPrivacyURLKey";
LZAppInfoKey LZAppInfoTermsOfUseURLKey = @"LZAppInfoPrivacyURLKey";

@interface LZAPPInfoTool ()
@property (nonatomic, strong) NSDictionary *infoPlist;
@property (nonatomic, copy, readwrite) NSString *appId;
@property (nonatomic, copy, readwrite) NSURL *privacyPolicyURL;
@property (nonatomic, copy, readwrite) NSURL *termsOfUseURL;
@end

@implementation LZAPPInfoTool
LZSingletonM

- (void)_setup {
    self.infoPlist = [[NSBundle mainBundle] infoDictionary];
    LZLoggerInfo(@"%@", self.infoPlist);
}

- (void)launchWithOption:(NSDictionary *)options {
    self.appId = options[LZAppInfoAppIdKey];
    self.privacyPolicyURL = options[LZAppInfoPrivacyURLKey];
    self.termsOfUseURL = options[LZAppInfoTermsOfUseURLKey];
}

- (NSString *)version { return self.infoPlist[@"CFBundleShortVersionString"]; }

- (NSString *)name { return self.infoPlist[@"CFBundleDisplayName"]; }

- (NSString *)buildVersion { return self.infoPlist[@"CFBundleVersion"]; }

- (NSString *)bundleId { return self.infoPlist[@"CFBundleIdentifier"]; }

- (NSString *)appId { return _appId ?: self.infoPlist[@"LZAppId"]; }

- (NSURL *)appStoreURL { return [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", self.appId]]; }

@end
