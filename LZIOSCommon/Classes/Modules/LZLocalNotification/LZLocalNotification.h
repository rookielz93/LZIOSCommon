//
//  LZLocalNotification.h
//  VideoDownloader
//
//  Created by lz on 2023/9/28.
//

#import <Foundation/Foundation.h>
#import "LZSingleton.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LZLocalNotificationAction) (BOOL success, NSError *error);

@interface LZLocalNotification : NSObject
LZSingletonH

@property (nonatomic, readonly, assign) BOOL authEnable;

- (void)launch;

- (void)request;

- (void)add:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body
       iden:(NSString *)iden delayDate:(NSDate *)delayDate
 completion:(LZLocalNotificationAction)completion;

- (void)add:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body
       iden:(NSString *)iden delayDuration:(NSTimeInterval)delayDuration
 completion:(LZLocalNotificationAction)completion;

- (void)remove:(NSString *)iden;

- (void)removeAll;

@end

NS_ASSUME_NONNULL_END
