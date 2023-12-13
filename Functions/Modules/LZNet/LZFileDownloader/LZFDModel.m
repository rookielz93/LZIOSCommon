//
//  LZFDModel.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/22.
//

#import "LZFDModel.h"

@implementation LZFDModel

- (instancetype)initWithUrl:(NSURL *)url
                  paraments:(nullable NSDictionary *)paraments
                 outputPath:(NSString *)outputPath {
    if (self = [super init]) {
        self.url = url;
        self.paraments = paraments;
        self.outputPath = outputPath;
    }
    return self;
}

@end
