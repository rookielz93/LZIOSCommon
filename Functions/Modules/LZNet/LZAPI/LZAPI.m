//
//  LZAPI.m
//  VideoDownloader
//
//  Created by lz on 2023/10/26.
//

#import "LZAPI.h"
//#import "LZNetManager.h"

@implementation LZAPI

- (void)run {
    
}

//- (void)getWithArgs:(NSDictionary *)args completion:(LZAPICompletion)completoin {
//    [LZNetManager get:self.url paraments:args completion:completoin];
//}
//
//- (void)postWithArgs:(NSDictionary *)args completion:(LZAPICompletion)completoin {
//    [LZNetManager post:self.url paraments:args completion:completoin];
//}
//
//- (void)downloadWithArgs:(NSDictionary *)args outputPath:(NSString *)outputPath progress:(LZAPIProgress)progress completion:(LZAPICompletion)completoin {
//    NSURL *url = [NSURL URLWithString:self.url];
//    [LZNetManager downloadFileWithUrl:url parameters:args outputPath:outputPath progress:^(NSProgress * _Nonnull downloadProgress) {
//        if (progress) progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
//    } completion:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nullable error) {
//        if (completoin) completoin(!error, nil, error);
//    }];
//}

@end
