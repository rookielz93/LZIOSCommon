//
//  LZNetManager.h
//  NewProject
//
//  Created by lz on 2019/3/31.
//  Copyright © 2019 new. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZSingleton.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LZNetManagerBlock) (BOOL isSuccess, NSDictionary * __nullable data, NSError * __nullable error);

@interface LZNetManager : NSObject
LZSingletonH

+ (void)post:(NSString *)url
   paraments:(NSDictionary *)paraments
  completion:(LZNetManagerBlock)completion;

+ (void)post:(NSString *)url
   paraments:(NSDictionary *)paraments
  retryCount:(int)retryCount
  completion:(LZNetManagerBlock)completion;

+ (void)get:(NSString *)url
  paraments:(nullable NSDictionary *)paraments
 completion:(LZNetManagerBlock)completion;

+ (void)get:(NSString *)url
  paraments:(nullable NSDictionary *)paraments
 retryCount:(int)retryCount
 completion:(LZNetManagerBlock)completion;

+ (void)get:(NSString *)url
  paraments:(nullable NSDictionary *)paraments
    headers:(nullable NSDictionary <NSString *, NSString *> *)headers
 completion:(LZNetManagerBlock)completion;

+ (void)get:(NSString *)url
  paraments:(nullable NSDictionary *)paraments
    headers:(nullable NSDictionary <NSString *, NSString *> *)headers
 retryCount:(int)retryCount
 completion:(LZNetManagerBlock)completion;

+ (NSURLSessionDownloadTask *)downloadFileWithUrl:(NSURL *)url
                                       parameters:(nullable NSDictionary *)parameters
                                       outputPath:(NSString *)outputPath
                                         progress:(void (^ _Nullable ) (NSProgress *downloadProgress))progress
                                       completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError * _Nullable error))completion;

@end

typedef enum : int {
    LZNetStatusUnknown = -1,
    LZNetStatusNotReachable,
    LZNetStatusReachableViaWWAN,
    LZNetStatusReachableViaWiFi
} LZNetStatus;

@protocol LZNetStatusDelegate <NSObject>

- (void)netStatusDidChanged:(LZNetStatus)status;

@end

@interface LZNetManager (NetStatus)

@property (nonatomic, assign, readonly) int observerCount;

- (void)startMonitoring;

- (void)stopMonitoring;

- (void)addObserver:(id<LZNetStatusDelegate>)observer;

- (void)removeObserver:(id<LZNetStatusDelegate>)observer;

- (LZNetStatus)getNetStatus;

@end

@interface LZNetManager (Common)

+ (nullable NSString *)getCurrentLocalIP;

@end

NS_ASSUME_NONNULL_END
