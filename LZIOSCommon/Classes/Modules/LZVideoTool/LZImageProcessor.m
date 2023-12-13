//
//  LZImageProcessor.m
//  VideoDownloader
//
//  Created by lz on 2023/10/28.
//

#import "LZImageProcessor.h"
#import "LZFileTool.h"
#import "LZLog.h"

#define LZIP_CHECK_PATH_VALID(path) ( ((path) && [(path) isKindOfClass:NSString.class] && (path).length>0 && [LZFileTool fileExist:(path)]) )
#define LZIP_CHECK_STR_VALID(str) ( ((str) && [(str) isKindOfClass:NSString.class] && (str).length>0) )
#define LZIP_CHECK_IMG_VALID(img) ( (img && [img isKindOfClass:[UIImage class]]) )

@implementation LZImageProcessor

+ (UIImage *)addWatermark:(NSString *)watermarkPath toImagePath:(NSString *)imagePath inScaleRect:(CGRect)scaleRect {
    if (!LZIP_CHECK_PATH_VALID(watermarkPath)) {
        LZLoggerError(@"watermark path is invalid");
        return nil;
    }
    
    if (!LZIP_CHECK_PATH_VALID(imagePath)) {
        LZLoggerError(@"imagePath path is invalid");
        return nil;
    }
    
    @autoreleasepool {
        UIImage *baseImg = [UIImage imageWithContentsOfFile:imagePath];
        return [self addWatermark:watermarkPath toImage:baseImg inScaleRect:scaleRect];
    }
}

+ (UIImage *)addWatermark:(NSString *)watermarkPath toImage:(UIImage *)baseImage inScaleRect:(CGRect)scaleRect {
    if (!LZIP_CHECK_PATH_VALID(watermarkPath)) {
        LZLoggerError(@"watermark path is invalid");
        return nil;
    }
    
    if (!LZIP_CHECK_IMG_VALID(baseImage)) {
        LZLoggerError(@"base image is invalid");
        return nil;
    }
    
    @autoreleasepool {
        UIImage *watermarkImg = [UIImage imageWithContentsOfFile:watermarkPath];
        return [self addWatermarkImg:watermarkImg toImage:baseImage inScaleRect:scaleRect];
    }
}

+ (nullable UIImage *)addWatermarkImg:(UIImage *)watermarkImg toImage:(UIImage *)baseImage inScaleRect:(CGRect)scaleRect {
    if (!LZIP_CHECK_IMG_VALID(watermarkImg)) {
        LZLoggerError(@"watermark image is invalid");
        return nil;
    }
    
    if (!LZIP_CHECK_IMG_VALID(baseImage)) {
        LZLoggerError(@"base image is invalid");
        return nil;
    }
    
    UIImage *ret = nil;
    @autoreleasepool {
        CGSize imageSize = baseImage.size;
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
        [baseImage drawAtPoint:CGPointZero];
        
        //    // 绘制文字水印
        //    NSString *str = @"水印文字";
        //    [str drawAtPoint:CGPointMake(30, 30) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor redColor]}];
        
        // 绘制图片水印
        [watermarkImg drawInRect:CGRectMake(imageSize.width * scaleRect.origin.x,
                                            imageSize.height * scaleRect.origin.y,
                                            imageSize.width * scaleRect.size.width,
                                            imageSize.height * scaleRect.size.height)];
        //    [logoImage drawAtPoint:CGPointMake(imageSize.width - logoImage.size.width - 30, imageSize.height - logoImage.size.height - 30)];
        
        // 获取图片
        ret = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();  // 关闭图片类型的图形上下文
        //    // 保存到相册中
        //    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
    }
    return ret;
}

@end
