//
//  LZVideoExporter.m
//  VideoDownloader
//
//  Created by lz on 2023/9/27.
//

#import "LZVideoExporter.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "LZFileTool.h"
#import "LZLog.h"

#define LZVE_CHECK_PATH_VALID(path) ( ((path) && [(path) isKindOfClass:NSString.class] && (path).length>0 && [LZFileTool fileExist:(path)]) )
#define LZVE_CHECK_STR_VALID(str) ( ((str) && [(str) isKindOfClass:NSString.class] && (str).length>0) )
#define LZVE_CHECK_IMG_VALID(img) ( (img && [img isKindOfClass:[UIImage class]]) )

@interface LZVideoExporter ()

@property (nonatomic, strong) AVAssetExportSession *exporter;

@end

@implementation LZVideoExporter

- (void)cancel {
    [self.exporter cancelExport];
}

- (void)exportWithOriginalVideoPath:(NSString *)videoPath
                      watermarkPath:(NSString *)watermarkPath
                  watermarkPosition:(LZVEWatermarkPosition)position
                         outputPath:(NSString *)outputPath
                         completion:(LZVideoExporterCompletion)completion {
    if (!LZVE_CHECK_PATH_VALID(videoPath)) {
        LZLoggerError(@"video path is invalid");
        return;
    }
    
    if (!LZVE_CHECK_PATH_VALID(watermarkPath)) {
        LZLoggerError(@"watermark path is invalid");
        return;
    }
    
    if (!LZVE_CHECK_STR_VALID(outputPath)) {
        LZLoggerError(@"output path is invalid");
        return;
    }
    
    @autoreleasepool {
        UIImage *watermarkImg = [UIImage imageWithContentsOfFile:watermarkPath];
        [self exportWithOriginalVideoPath:videoPath
                             watermarkImg:watermarkImg
                        watermarkPosition:position
                               outputPath:outputPath
                               completion:completion];
    }
}

- (void)exportWithOriginalVideoPath:(NSString *)videoPath
                       watermarkImg:(UIImage *)watermarkImg
                  watermarkPosition:(LZVEWatermarkPosition)position
                         outputPath:(NSString *)outputPath
                         completion:(LZVideoExporterCompletion)completion {
    [self _exportWithOriginalVideoPath:videoPath
                         watermarkImg:watermarkImg
                     watermarkPosition:position
                   watermarkScaleRect:CGRectZero
                           outputPath:outputPath
                           completion:completion];
}

- (void)exportWithOriginalVideoPath:(NSString *)videoPath
                      watermarkPath:(NSString *)watermarkPath
                 watermarkScaleRect:(CGRect)watermarkScaleRect
                         outputPath:(NSString *)outputPath
                         completion:(LZVideoExporterCompletion)completion {
    if (!LZVE_CHECK_PATH_VALID(videoPath)) {
        LZLoggerError(@"video path is invalid");
        return;
    }
    
    if (!LZVE_CHECK_PATH_VALID(watermarkPath)) {
        LZLoggerError(@"watermark path is invalid");
        return;
    }
    
    if (!LZVE_CHECK_STR_VALID(outputPath)) {
        LZLoggerError(@"output path is invalid");
        return;
    }
    
    @autoreleasepool {
        UIImage *watermarkImg = [UIImage imageWithContentsOfFile:watermarkPath];
        [self exportWithOriginalVideoPath:videoPath
                             watermarkImg:watermarkImg
                       watermarkScaleRect:watermarkScaleRect
                               outputPath:outputPath
                               completion:completion];
    }
}

- (void)exportWithOriginalVideoPath:(NSString *)videoPath
                       watermarkImg:(UIImage *)watermarkImg
                 watermarkScaleRect:(CGRect)watermarkScaleRect
                         outputPath:(NSString *)outputPath
                         completion:(LZVideoExporterCompletion)completion {
    [self _exportWithOriginalVideoPath:videoPath
                          watermarkImg:watermarkImg
                     watermarkPosition:(LZVEWatermarkPositionLeftBottom)
                    watermarkScaleRect:watermarkScaleRect
                            outputPath:outputPath
                            completion:completion];
}

- (void)_exportWithOriginalVideoPath:(NSString *)videoPath
                        watermarkImg:(UIImage *)watermarkImg
                   watermarkPosition:(LZVEWatermarkPosition)position
                  watermarkScaleRect:(CGRect)watermarkScaleRect
                          outputPath:(NSString *)outputPath
                          completion:(LZVideoExporterCompletion)completion {
    LZLoggerInfo(@"%@, %@, %@", videoPath, watermarkImg, outputPath);
    
    if (!LZVE_CHECK_PATH_VALID(videoPath)) {
        LZLoggerError(@"video path is invalid");
        return;
    }

    if (!LZVE_CHECK_IMG_VALID(watermarkImg)) {
        LZLoggerError(@"water mark img is nil");
        return;
    }
    
    if (!LZVE_CHECK_STR_VALID(outputPath)) {
        LZLoggerError(@"output path is invalid");
        return;
    }
    
    NSError *error = nil;
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath] options:@{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES}];
    AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    if (!videoTrack) {
        LZLoggerError(@"video track is nil");
        return;
    }

    CGSize videoSize = [videoTrack naturalSize];
    CALayer *watermarkLayer = [CALayer layer];
    watermarkLayer.contents = (id)watermarkImg.CGImage;
    watermarkLayer.opacity = 1.0;
    CGRect watermarkRect = CGRectZero;
    if (CGRectIsEmpty(watermarkScaleRect)) {
        watermarkRect.size = watermarkImg.size;
        switch (position) {
            case LZVEWatermarkPositionLeftBottom:
            {
                watermarkRect.origin.x = 0;
                watermarkRect.origin.y = videoSize.height - watermarkImg.size.height;
            }
                break;
            case LZVEWatermarkPositionRightBottom:
            {
                watermarkRect.origin.x = videoSize.width - watermarkImg.size.width;
                watermarkRect.origin.y = videoSize.height - watermarkImg.size.height;
            }
                break;
            case LZVEWatermarkPositionRightTop:
            {
                watermarkRect.origin.x = videoSize.width - watermarkImg.size.width;
                watermarkRect.origin.y = 0;
            }
                break;
            case LZVEWatermarkPositionLeftTop:
            {
                watermarkRect.origin.x = 0;
                watermarkRect.origin.y = 0;
            }
                break;
        }
    } else {
        watermarkRect = CGRectMake(videoSize.width * watermarkScaleRect.origin.x,
                                   videoSize.height * watermarkScaleRect.origin.y,
                                   videoSize.width * watermarkScaleRect.size.width,
                                   videoSize.height * watermarkScaleRect.size.height);
    }
    watermarkLayer.frame = watermarkRect;
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:watermarkLayer];
    parentLayer.geometryFlipped = YES;
    
    AVMutableVideoComposition *videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = videoSize;
    videoComp.frameDuration = CMTimeMake(1, 30);
    // 应用 Core Animation Framework 框架中的动画效果
    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [asset duration]);
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    // layerInstructions 属性中所存储的 layer instructions 的顺序决定了 tracks 中的视频帧是如何被放置和组合的。
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComp.instructions = @[ instruction ];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.videoComposition = videoComp;
    exporter.outputURL = [NSURL fileURLWithPath:outputPath];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        LZLoggerInfo(@"merge %d, %@", (int)exporter.status, exporter.error);
        completion(self, outputPath, error);
    }];
    self.exporter = exporter;
}

@end
