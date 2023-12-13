//
//  LZFDModel.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZFDModel : NSObject

- (instancetype)initWithUrl:(NSURL *)url
                  paraments:(nullable NSDictionary *)paraments
                 outputPath:(NSString *)outputPath;

@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSDictionary *paraments;
@property (nonatomic, copy) NSString *outputPath;

@end

NS_ASSUME_NONNULL_END
