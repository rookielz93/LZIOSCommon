//
//  LZAlert.h
//  VideoDownloader
//
//  Created by lz on 2023/9/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZAlert : NSObject

+ (UIViewController *)rootViewController;

+ (void)gotoSysSetting;

+ (void)showAndGotoSysSetting:(NSString *)titile
                      message:(NSString *)message;

+ (void)show:(NSString *)titile
     message:(NSString *)message
cancelAction:(nullable dispatch_block_t)cancelAction
    okAction:(nullable dispatch_block_t)okAction;

+ (void)show:(NSString *)titile
     message:(NSString *)message
 cancelTitle:(NSString *)cancelTitle
     okTitle:(NSString *)okTitle
cancelAction:(nullable dispatch_block_t)cancelAction
    okAction:(nullable dispatch_block_t)okAction;

@end

NS_ASSUME_NONNULL_END
