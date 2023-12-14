//
//  LZAPPInfoTool.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import <Foundation/Foundation.h>
#import "LZSingleton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString* LZAppInfoKey;
extern LZAppInfoKey LZAppInfoAppIdKey;
extern LZAppInfoKey LZAppInfoPrivacyURLKey;
extern LZAppInfoKey LZAppInfoTermsOfUseURLKey;

@interface LZAPPInfoTool : NSObject
LZSingletonH

- (void)launchWithOption:(NSDictionary *)options;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *version;
@property (nonatomic, strong, readonly) NSString *buildVersion;
@property (nonatomic, strong, readonly) NSString *bundleId;
@property (nonatomic, copy, readonly) NSString *appId;

@property (nonatomic, strong, readonly) NSURL *appStoreURL;
@property (nonatomic, copy, readonly) NSURL *privacyPolicyURL;
@property (nonatomic, copy, readonly) NSURL *termsOfUseURL;

@end

NS_ASSUME_NONNULL_END
