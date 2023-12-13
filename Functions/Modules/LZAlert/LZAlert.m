//
//  LZAlert.m
//  VideoDownloader
//
//  Created by lz on 2023/9/28.
//

#import "LZAlert.h"

@implementation LZAlert

+ (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

+ (void)gotoSysSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            LZLoggerError(@"failed to open %@, because no find open function", url);
        }
    } else {
        LZLoggerError(@"can't open %@", url);
    }
}

+ (void)showAndGotoSysSetting:(NSString *)titile
                      message:(NSString *)message {
    [LZAlert show:titile message:message
      cancelTitle:@"取消" okTitle:@"设置"
     cancelAction:nil okAction:^{
        [LZAlert gotoSysSetting];
    }];
}

+ (void)show:(NSString *)titile
     message:(NSString *)message
cancelAction:(nullable dispatch_block_t)cancelAction
    okAction:(nullable dispatch_block_t)okAction {
    [self show:titile message:message
   cancelTitle:@"取消" okTitle:@"确定"
  cancelAction:cancelAction okAction:okAction];
}

+ (void)show:(NSString *)titile
     message:(NSString *)message
 cancelTitle:(nonnull NSString *)cancelTitle
     okTitle:(nonnull NSString *)okTitle
cancelAction:(nullable dispatch_block_t)cancelAction
    okAction:(nullable dispatch_block_t)okAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titile
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (cancelAction) cancelAction();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (okAction) okAction();
    }]];
    [self.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
