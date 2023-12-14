//
//  LZPasteboardManager.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/11.
//

#import "LZPasteboardManager.h"
#import <UIKit/UIKit.h>
#import "LZGCD.h"
#import "LZLog.h"

@implementation LZPasteboardContent

+ (instancetype)type:(NSString *)type content:(NSString *)content {
    LZPasteboardContent *ret = [LZPasteboardContent new];
    ret.type = type;
    ret.content = content;
    return ret;
}

+ (BOOL)isSame:(LZPasteboardContent *)a b:(LZPasteboardContent *)b; {
    if (a == b) return YES;
    if (!a || !b) return NO;
    return ((a.type == b.type) && (a.content == b.content));
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@", self.type, self.content];
}

@end

@interface LZPasteboardManager ()

@property (nonatomic, strong, readonly) UIPasteboard *sysPB;
@property (nonatomic, strong) NSHashTable <id<LZPasteboardDelegate>>*observers;
@property (nonatomic, strong) LZGCD *gcd;
@property (nonatomic, assign) NSInteger changedCount; // 系统粘贴板改变的次数
@property (nonatomic, strong) LZPasteboardContent *curContent;

@end

@implementation LZPasteboardManager
LZSingletonM

- (void)_setup {
    self.gcd = [[LZGCD alloc] initWithName:@"lz.gcd.pb.manager"];
    self.observers = [NSHashTable weakObjectsHashTable];
    _changedCount = self.sysPB.changeCount;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_appDidEnterBackround) name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_appDidEnterForeground)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    /*
    //  不起作用
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_pbDidChanged:) name:UIPasteboardChangedNotification object:self.sysPB];
     
    [self.sysPB addObserver:self forKeyPath:@"changeCount" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
         [self.sysPB addObserver:self forKeyPath:@"string" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_pbDidChanged:) name:UIPasteboardChangedNotification object:self.sysPB];
     }
     
     - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
         LZLoggerInfo(@"%@", keyPath);
     }
     
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [UIPasteboard generalPasteboard].string = @"2222"; // 可以收到通知和监听
         });
     */
}

// MARK: - Notification

- (void)_appDidEnterBackround {
    self.changedCount = self.sysPB.changeCount;
}

- (void)_appDidEnterForeground {
    self.changedCount = self.sysPB.changeCount;
//    LZLoggerInfo(@"dddd: %ld, %@", (long)self.sysPB.changeCount, self.sysPB.pasteboardTypes);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    LZLoggerInfo(@"%@", keyPath);
}

// MARK: - Observers

- (void)getContent:(LZPasteboardGetContent)completion {
    if (!completion) {
        LZLoggerError(@"completion is nil, return");
        return;
    }
    [self _getCurrentContent:completion];
}

- (BOOL)isURLForContent {
    return [[UIPasteboard generalPasteboard] hasURLs];
}

- (int)observerCount {
    return (int)self.observers.count;
}

- (void)addObserver:(id<LZPasteboardDelegate>)observer {
    [self.gcd async:^{
        [self.observers addObject:observer];
    }];
}

- (void)removeObserver:(id<LZPasteboardDelegate>)observer {
    [self.gcd async:^{
        [self.observers removeObject:observer];
    }];
}

// MARK: - Priv

- (void)_getCurrentContent:(LZPasteboardGetContent)completion {
    LZPasteboardGetContent internalCompletion = ^(LZPasteboardContent *content) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.curContent = content;
            completion(content);
        });
    };
    
    if (@available(iOS 14.0, *)) {
        // UIPasteboardDetectionPatternProbableWebSearch is text
        NSSet *patterns = [NSSet setWithObjects:UIPasteboardDetectionPatternProbableWebURL, nil];
        [[UIPasteboard generalPasteboard] detectValuesForPatterns:patterns completionHandler:^(NSDictionary<UIPasteboardDetectionPattern,id> *wrapper, NSError *error) {
            LZLoggerInfo(@"%@, error: %@", wrapper, error);
            
            LZPasteboardContent *content = nil;
            if (!error) {
                content = [LZPasteboardContent type:wrapper.allKeys.firstObject content:wrapper.allValues.firstObject];
            }
            internalCompletion(content);
        }];
    } else {
        internalCompletion([LZPasteboardContent type:nil content:self.sysPB.URL.absoluteString]);
    }
}

- (void)_pbDidChanged {
    for (id<LZPasteboardDelegate>observer in self.observers.allObjects) {
        if ([observer respondsToSelector:@selector(pasteboardDidChanged:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [observer pasteboardDidChanged:self];
            });
        }
    }
}

- (void)_setChangedCount:(NSInteger)changedCount {
    if (_changedCount == changedCount) {
        return;
    }
    _changedCount = changedCount;
    [self _pbDidChanged];
}

// MARK: - Props

- (UIPasteboard *)sysPB {
    return [UIPasteboard generalPasteboard];
}

- (void)setChangedCount:(NSInteger)changedCount {
    [self.gcd async:^{
        [self _setChangedCount:changedCount];
    }];
}

@end
