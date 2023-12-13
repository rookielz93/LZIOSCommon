//
//  LZFileDownloader.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/22.
//

#import <Foundation/Foundation.h>
#import "LZTaskProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZFileDownloader : NSObject <LZTaskExecuterProtocol>

- (instancetype)initWithArg:(nullable id)arg;

- (void)execute:(id)source // source is LZFDModel
       progress:(nullable LZTaskExecuterProgress)progress
     completion:(nullable LZTaskExecuterCompletion)completion;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
