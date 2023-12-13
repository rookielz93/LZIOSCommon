//
//  LZVideoExporter.h
//  VideoDownloader
//
//  Created by lz on 2023/9/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : int {
    LZVEWatermarkPositionLeftBottom = 0,
    LZVEWatermarkPositionRightBottom,
    LZVEWatermarkPositionRightTop,
    LZVEWatermarkPositionLeftTop
} LZVEWatermarkPosition;

@class LZVideoExporter;
typedef void (^LZVideoExporterCompletion) (LZVideoExporter *exporter, NSString *outputPath, NSError *error);

@interface LZVideoExporter : NSObject

- (void)exportWithOriginalVideoPath:(NSString *)videoPath
                      watermarkPath:(NSString *)watermarkPath
                  watermarkPosition:(LZVEWatermarkPosition)position
                         outputPath:(NSString *)outputPath
                         completion:(LZVideoExporterCompletion)completion;

- (void)exportWithOriginalVideoPath:(NSString *)videoPath
                       watermarkImg:(UIImage *)watermarkImg
                  watermarkPosition:(LZVEWatermarkPosition)position
                         outputPath:(NSString *)outputPath
                         completion:(LZVideoExporterCompletion)completion;

- (void)exportWithOriginalVideoPath:(NSString *)videoPath
                      watermarkPath:(NSString *)watermarkPath
                 watermarkScaleRect:(CGRect)watermarkScaleRect
                         outputPath:(NSString *)outputPath
                         completion:(LZVideoExporterCompletion)completion;

- (void)exportWithOriginalVideoPath:(NSString *)videoPath
                       watermarkImg:(UIImage *)watermarkImg
                 watermarkScaleRect:(CGRect)watermarkScaleRect
                         outputPath:(NSString *)outputPath
                         completion:(LZVideoExporterCompletion)completion;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
