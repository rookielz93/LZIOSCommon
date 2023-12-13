//
//  LZAPPInfoTool.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import "LZAPPInfoTool.h"
#import "LZLog.h"

@interface LZAPPInfoTool ()
@property (nonatomic, strong) NSDictionary *infoPlist;
@end

@implementation LZAPPInfoTool
LZSingletonM

- (void)_setup {
    self.infoPlist = [[NSBundle mainBundle] infoDictionary];
    LZLoggerInfo(@"%@", self.infoPlist);
}

- (NSString *)version { return self.infoPlist[@"CFBundleShortVersionString"]; }

- (NSString *)name { return self.infoPlist[@"CFBundleDisplayName"]; }

- (NSString *)buildVersion { return self.infoPlist[@"CFBundleVersion"]; }

- (NSString *)bundleId { return self.infoPlist[@"CFBundleIdentifier"]; }

- (NSURL *)appStoreURL { return [NSURL URLWithString:@"https://itunes.apple.com/app/id6471901130"]; }

- (NSURL *)privacyPolicyURL {
    return [NSURL URLWithString:@"https://docs.qq.com/doc/p/432febfe94d125bda8465780e1d9588f51ea6e26?u=913f83c235864245b2f63f1ed92aab37"];
}

- (NSURL *)termsOfUseURL {
    return [NSURL URLWithString:@"https://docs.qq.com/doc/p/7c74bfcbc3b6cc8dadfe4acb903b5a209c184d39?u=913f83c235864245b2f63f1ed92aab37"];
}

@end
