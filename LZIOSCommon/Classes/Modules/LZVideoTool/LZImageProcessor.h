//
//  LZImageProcessor.h
//  VideoDownloader
//
//  Created by lz on 2023/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZImageProcessor : NSObject

+ (nullable UIImage *)addWatermark:(NSString *)watermarkPath toImagePath:(NSString *)imagePath inScaleRect:(CGRect)scaleRect;

+ (nullable UIImage *)addWatermark:(NSString *)watermarkPath toImage:(UIImage *)baseImage inScaleRect:(CGRect)scaleRect;

+ (nullable UIImage *)addWatermarkImg:(UIImage *)watermarkImg toImage:(UIImage *)baseImage inScaleRect:(CGRect)scaleRect;

@end

NS_ASSUME_NONNULL_END
