//
//  LZLocalNotification.m
//  VideoDownloader
//
//  Created by lz on 2023/9/28.
//

#import "LZLocalNotification.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import "LZAlert.h"
#import "LZGCD.h"
#import "LZCond.h"
#import "LZLog.h"

@interface LZLocalNotification ()
@property (nonatomic, strong) UNUserNotificationCenter *center;
@end
@interface LZLocalNotification (Delegate) <UNUserNotificationCenterDelegate>
@end

@implementation LZLocalNotification
LZSingletonM

- (void)_setup {
    _center = [UNUserNotificationCenter currentNotificationCenter];
    _center.delegate = self;
}

- (BOOL)authEnable {
    __block BOOL enable = NO;
    LZCond *cond = [LZCond new];
    [self.center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        enable = (settings.notificationCenterSetting == UNNotificationSettingEnabled);
        [cond signal];
    }];
    [cond wait];
    return enable;
}

- (void)launch {
    [self.center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound)
                               completionHandler:^(BOOL granted, NSError *error) {
        LZLoggerInfo(@"%d, %@", granted, error);
    }];
}

- (void)request {
    [LZAlert showAndGotoSysSetting:@"通知" message:@"未获得通知权限，请前去设置"];
}

- (void)add:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body
       iden:(NSString *)iden delayDate:(NSDate *)delayDate
 completion:(LZLocalNotificationAction)completion {
    NSTimeInterval duration = [delayDate timeIntervalSinceNow];
    [self add:title subtitle:subtitle body:body iden:iden delayDuration:duration completion:completion];
}

- (void)add:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body
       iden:(NSString *)iden delayDuration:(NSTimeInterval)delayDuration
 completion:(LZLocalNotificationAction)completion {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subtitle;
    content.body = body; // @"测试通知的具体内容";
    // 声音
    content.sound = [UNNotificationSound defaultSound]; // 默认声音
    // 添加自定义声音
    // content.sound = [UNNotificationSound soundNamed:@"Alert_ActivityGoalAttained_Salient_Haptic.caf"];
    content.badge = @1;
    // repeats，是否重复，如果重复的话时间必须大于60s，要不会报错
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:delayDuration repeats:NO];
    /*
    //如果想重复可以使用这个,按日期
    // 周一早上 8：00 上班
    NSDateComponents *components = [[NSDateComponents alloc] init];
    // 注意，weekday默认是从周日开始
    components.weekday = 2;
    components.hour = 8;
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    */
    // 添加通知的标识符，可以用于移除，更新等操作
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:iden content:content trigger:trigger];
    [self.center addNotificationRequest:request withCompletionHandler:^(NSError *error) {
        LZLoggerInfo(@"add request %@, error: %@", request, error);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(!error, error);
        });
    }];
}

- (void)remove:(NSString *)iden {
    if (!iden || ![iden isKindOfClass:NSString.class] || iden.length==0) {
        LZLoggerError(@"iden is in valid, return");
        return;
    }
    
    [self.center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *>* requests) {
        LZLoggerInfo(@"%@", requests);
    }];
    [self.center removePendingNotificationRequestsWithIdentifiers:@[ iden ]];
}

- (void)removeAll {
    [self.center removeAllPendingNotificationRequests];
}

@end

@implementation LZLocalNotification (Delegate)

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    LZLoggerBaseInfo;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    LZLoggerBaseInfo;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification {
    LZLoggerBaseInfo;
}

@end
