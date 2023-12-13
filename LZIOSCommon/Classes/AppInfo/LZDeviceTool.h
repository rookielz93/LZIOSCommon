//
//  LZDeviceTool.h
//  VideoDownloader
//
//  Created by lz on 2023/9/11.
//

#import <Foundation/Foundation.h>
#import "LZSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZDeviceTool : NSObject
LZSingletonH

/// Base
@property (nonatomic, readonly, strong) NSString *name;  // Synonym for model. Prior to iOS 16, user-assigned device name (e.g. @"My iPhone").
@property (nonatomic, readonly, strong) NSString *model; // e.g. @"iPhone", @"iPod touch"
@property (nonatomic, readonly, strong) NSString *localizedModel; // localized version of model
@property (nonatomic, readonly, strong) NSString *systemName;  // e.g. @"iOS"
@property (nonatomic, readonly, strong) NSString *systemVersion;  // e.g. @"4.0"

/// Battery
@property (nonatomic, readonly) float batteryLevel;

/// Locale
@property (nonatomic, readonly, strong) NSString *country;

/// 运营商信息
@property (nonatomic, readonly, strong) NSString *carrierName;

@end

NS_ASSUME_NONNULL_END
