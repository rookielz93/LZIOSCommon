//
//  LZImageGenerator.h
//  VideoDownloader
//
//  Created by lz on 2023/10/31.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LZImageGeneratorFrameCompletion) (BOOL success, NSError * _Nullable error, CMTime requestedTime, CGImageRef _Nullable image, CMTime actualTime);
typedef void (^LZImageGeneratorAllCompletion) (void);

@interface LZImageGenerator : NSObject

+ (void)generateFirstFrame:(NSString *)path
                      size:(CGSize)size
             needPrecision:(BOOL)needPrecision
                completion:(LZImageGeneratorFrameCompletion)completion;

+ (void)generate:(NSString *)path
            size:(CGSize)size
   needPrecision:(BOOL)needPrecision
  requestedTimes:(NSArray<NSValue *> *)requestedTimes
 frameCompletion:(LZImageGeneratorFrameCompletion)frameCompletion
   allCompletion:(nullable LZImageGeneratorAllCompletion)allCompletion;

@end

NS_ASSUME_NONNULL_END
