//
//  LZImageGenerator.m
//  VideoDownloader
//
//  Created by lz on 2023/10/31.
//

#import "LZImageGenerator.h"
#import "LZLog.h"

@implementation LZImageGenerator

+ (void)generateFirstFrame:(NSString *)path
                      size:(CGSize)size
             needPrecision:(BOOL)needPrecision
                completion:(LZImageGeneratorFrameCompletion)completion {
    [self generate:path size:size
     needPrecision:needPrecision
    requestedTimes:@[ [NSValue valueWithCMTime:kCMTimeZero] ]
   frameCompletion:completion allCompletion:nil];
}

+ (void)generate:(NSString *)path
            size:(CGSize)size
   needPrecision:(BOOL)needPrecision
  requestedTimes:(NSArray<NSValue *> *)requestedTimes
 frameCompletion:(LZImageGeneratorFrameCompletion)frameCompletion
   allCompletion:(LZImageGeneratorAllCompletion)allCompletion {
    
    if (!path || ![path isKindOfClass:[NSString class]] || path.length==0 || ![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        LZLoggerInfo(@"path is invalid, return");
        if (allCompletion) allCompletion();
        return;
    }
    
    AVAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        imageGenerator.maximumSize = size;
    }
    imageGenerator.appliesPreferredTrackTransform = YES;

    if (needPrecision) {
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    }

    __block int doneCount = 0;
    [imageGenerator generateCGImagesAsynchronouslyForTimes:requestedTimes completionHandler:^(CMTime requestedTime, CGImageRef _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            doneCount ++;
            if (frameCompletion) frameCompletion(!error, error, requestedTime, image, actualTime);
            if (doneCount == requestedTimes.count) {
                if (allCompletion) allCompletion();
            }
        });
    }];
}

@end
