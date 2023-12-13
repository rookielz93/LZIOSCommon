//
//  LZAPPInfoTool.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/12.
//

#import <Foundation/Foundation.h>
#import "LZSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZAPPInfoTool : NSObject
LZSingletonH

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *version;
@property (nonatomic, strong, readonly) NSString *buildVersion;
@property (nonatomic, strong, readonly) NSString *bundleId;

@property (nonatomic, strong, readonly) NSURL *appStoreURL;
@property (nonatomic, strong, readonly) NSURL *privacyPolicyURL;
@property (nonatomic, strong, readonly) NSURL *termsOfUseURL;

@end

NS_ASSUME_NONNULL_END
