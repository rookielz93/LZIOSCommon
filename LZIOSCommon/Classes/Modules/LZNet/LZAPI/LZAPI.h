//
//  LZAPI.h
//  VideoDownloader
//
//  Created by lz on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LZAPICompletion) (BOOL isSuccess, id __nullable data, NSError * __nullable error);
typedef void (^LZAPIProgress) (float progress);

@interface LZAPI : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSDictionary *args;
@property (nonatomic, copy) LZAPIProgress processCb;
@property (nonatomic, copy) LZAPICompletion completionCb;

- (void)run;

@end

NS_ASSUME_NONNULL_END
