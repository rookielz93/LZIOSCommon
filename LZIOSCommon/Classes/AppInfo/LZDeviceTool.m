//
//  LZDeviceTool.m
//  VideoDownloader
//
//  Created by lz on 2023/9/11.
//

#import "LZDeviceTool.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UIKit/UIKit.h>
#import "LZLog.h"

@interface LZDeviceTool ()

@property (nonatomic, strong) UIDevice *device;

@end

@implementation LZDeviceTool
LZSingletonM

- (void)_setup {
    self.device = [UIDevice currentDevice];
}

// MARK: - Base

- (NSString *)name { return self.device.name; }

- (NSString *)model { return self.device.model; }

- (NSString *)localizedModel { return self.device.localizedModel; }

- (NSString *)systemName { return self.device.systemName; }

- (NSString *)systemVersion { return self.device.systemVersion; }

// MARK: - Battery

- (float)batteryLevel { return self.device.batteryLevel; }

// MARK: - Locale

- (NSString *)country { return [[NSLocale currentLocale] localeIdentifier]; }

// MARK: - 运营商信息
- (NSString *)carrierName {
    CTTelephonyNetworkInfo *infomation = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [infomation subscriberCellularProvider];
    return [carrier carrierName];
}

@end
