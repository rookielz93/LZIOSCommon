//
//  LZPasteboardManager.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/11.
//

#import <Foundation/Foundation.h>
#import "LZSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZPasteboardContent : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
+ (instancetype)type:(nullable NSString *)type content:(NSString *)content;
+ (BOOL)isSame:(LZPasteboardContent *)a b:(LZPasteboardContent *)b;
@end

@class LZPasteboardManager;
@protocol LZPasteboardDelegate <NSObject> // 目前只关注了从后台到前台的变化

- (void)pasteboardDidChanged:(LZPasteboardManager *)pasteboard;

@end

typedef void (^LZPasteboardGetContent) (LZPasteboardContent *content);
@interface LZPasteboardManager : NSObject
LZSingletonH

@property (nonatomic, assign, readonly) int observerCount;

- (void)addObserver:(id<LZPasteboardDelegate>)observer;

- (void)removeObserver:(id<LZPasteboardDelegate>)observer;

- (BOOL)isURLForContent;
- (void)getContent:(LZPasteboardGetContent)completion;

@end

NS_ASSUME_NONNULL_END
