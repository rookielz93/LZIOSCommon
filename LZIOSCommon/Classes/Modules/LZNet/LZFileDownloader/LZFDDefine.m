//
//  LZFDDefine.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/18.
//

#import "LZFDDefine.h"

@implementation LZFDDefine

+ (NSString *)descForFDStatus:(LZFDStatus)status {
    switch (status) {
        case LZFDStatusDownloading: return @"downloading";
        case LZFDStatusDownloaded: return @"downloaded";
        case LZFDStatusCancelled: return @"cancelled";
        default: return nil;
    }
}

@end
