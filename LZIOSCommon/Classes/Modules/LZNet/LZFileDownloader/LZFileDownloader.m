//
//  LZFileDownloader.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/22.
//

#import "LZFileDownloader.h"
#import "LZGCD.h"
#import "LZNetManager.h"
#import "LZFDModel.h"

@interface LZFileDownloader ()

@property (nonatomic, copy)   LZTaskExecuterProgress progress;
@property (nonatomic, copy)   LZTaskExecuterCompletion completion;
@property (nonatomic, strong) LZGCD *gcd;

@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@end

@interface LZFileDownloader (Internal)
- (void)_reset;
- (void)_cancel;
- (void)_progress:(NSProgress *)progress;
- (void)_completion:(NSURLResponse *)response error:(NSError *)error;
@end

@implementation LZFileDownloader

- (instancetype)initWithArg:(id)arg {
    if (self = [super init]) {
        _gcd = [[LZGCD alloc] initWithName:@"com.lz.file.downloader.queue"];
    }
    return self;
}

- (void)execute:(id)source progress:(LZTaskExecuterProgress)progress completion:(LZTaskExecuterCompletion)completion {
    [self.gcd async:^{
        [self _reset];
        self.progress = progress;
        self.completion = completion;
        
        LZFDModel *model = (LZFDModel *)source;
        self.task = [LZNetManager downloadFileWithUrl:model.url
                                           parameters:model.paraments
                                           outputPath:model.outputPath
                                             progress:^(NSProgress * _Nonnull downloadProgress) {
            [self _progress:downloadProgress];
        } completion:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nullable error) {
            [self _completion:response error:error];
        }];
    }];
}

- (void)cancel {
    [self.gcd async:^{
        [self _cancel];
    }];
}

@end

@implementation LZFileDownloader (Internal)

- (void)_reset {
    self.task = nil;
}

- (void)_cancel {
    [self.task cancel];
}

- (void)_progress:(NSProgress *)progress {
    [self.gcd async:^{
        [self __progress:progress];
    }];
}

- (void)_completion:(NSURLResponse *)response error:(NSError *)error {
    [self.gcd async:^{
        [self __completion:response error:error];
    }];
}

- (void)__progress:(NSProgress *)progress {
    if (!self.progress) return;
    
    self.progress(1.0 * progress.completedUnitCount / progress.totalUnitCount);
}

- (void)__completion:(NSURLResponse *)response error:(NSError *)error {
    if (!self.completion) return;
    
    self.completion(nil, error);
    self.progress = nil;
    self.completion = nil;
    self.task = nil;
}

@end
