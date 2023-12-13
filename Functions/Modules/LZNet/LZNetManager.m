//
//  LZNetManager.m
//  NewProject
//
//  Created by lz on 2019/3/31.
//  Copyright © 2019 new. All rights reserved.
//

#import "LZNetManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "LZGCD.h"
#import "LZWeakifyStrongify.h"
#import "LZLog.h"

@interface LZNetManager ()

// net status
@property (strong, nonatomic) AFNetworkReachabilityManager *netStatusManager;
@property (nonatomic, strong) NSHashTable <id<LZNetStatusDelegate>>*observers;
// http
@property (strong, nonatomic) AFHTTPSessionManager *httpManager;
// download
@property (strong, nonatomic) AFHTTPSessionManager *downloadManager;
// safe thread
@property (nonatomic, strong) LZGCD *gcd;
@property (nonatomic, assign) int retryCount;

@end

@implementation LZNetManager
LZSingletonM

- (void)_setup {
    self.netStatusManager = [AFNetworkReachabilityManager sharedManager];
    
    self.httpManager = [AFHTTPSessionManager new];
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    self.httpManager.requestSerializer.timeoutInterval = 20.0;
    self.downloadManager = [AFHTTPSessionManager new];
    self.gcd = [[LZGCD alloc] initWithName:@"lz.gcd.net.manager"];
    self.retryCount = 5;
}

// MARK: - Data

+ (void)post:(NSString *)url
   paraments:(NSDictionary *)paraments
  completion:(LZNetManagerBlock)completion {
    [self post:url paraments:paraments retryCount:[[self sharedInstance] retryCount] completion:completion];
}

+ (void)post:(NSString *)url
   paraments:(NSDictionary *)paraments
  retryCount:(int)retryCount
  completion:(LZNetManagerBlock)completion {
    if (!completion) {
        LZLoggerError(@"completion is nil, return");
        return;
    }
    
    [self _post:url paraments:paraments completion:^(BOOL isSuccess, NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (isSuccess || retryCount <= 0) {
            completion(isSuccess, data, error);
        } else {
            [self post:url paraments:paraments retryCount:(retryCount - 1) completion:completion];
        }
    }];
}

+ (void)get:(NSString *)url
  paraments:(NSDictionary *)paraments
 completion:(LZNetManagerBlock)completion {
    [self get:url paraments:paraments headers:nil completion:completion];
}

+ (void)get:(NSString *)url
  paraments:(NSDictionary *)paraments
    headers:(nullable NSDictionary <NSString *, NSString *> *)headers
 completion:(LZNetManagerBlock)completion {
    [self get:url paraments:paraments headers:headers retryCount:[[self sharedInstance] retryCount] completion:completion];
}

+ (void)get:(NSString *)url
  paraments:(nullable NSDictionary *)paraments
 retryCount:(int)retryCount
 completion:(LZNetManagerBlock)completion {
    [self get:url paraments:paraments headers:nil retryCount:retryCount completion:completion];
}

+ (void)get:(NSString *)url
  paraments:(nullable NSDictionary *)paraments
    headers:(nullable NSDictionary <NSString *, NSString *> *)headers
 retryCount:(int)retryCount
 completion:(LZNetManagerBlock)completion {
    if (!completion) {
        LZLoggerError(@"completion is nil, return");
        return;
    }
    
    [self _get:url paraments:paraments headers:headers completion:^(BOOL isSuccess, NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (isSuccess || retryCount <= 0) {
            completion(isSuccess, data, error);
        } else {
            [self get:url paraments:paraments headers:headers retryCount:(retryCount - 1) completion:completion];
        }
    }];
}

+ (NSURLSessionDownloadTask *)downloadFileWithUrl:(NSURL *)url
                                       parameters:(NSDictionary *)parameters
                                       outputPath:(NSString *)outputPath
                                         progress:(void (^)(NSProgress *downloadProgress))progress
                                       completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError * _Nullable error))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [[[self sharedInstance] httpManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:outputPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        LZLoggerInfo(@"%@, %@, %@", response, error, filePath);
        if (completion) completion(response, filePath, error);
    }];
    [task resume];
    return task;
}

// MARK: - Private

+ (void)_get:(NSString *)url
   paraments:(NSDictionary *)paraments
     headers:(nullable NSDictionary <NSString *, NSString *> *)headers
  completion:(LZNetManagerBlock)completion
{
    [[[self sharedInstance] httpManager] GET:url parameters:paraments headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
        if (@available(iOS 11.0, *)) {
            LZLoggerInfo(@"完成：%.2f", downloadProgress.fileCompletedCount.floatValue / downloadProgress.fileTotalCount.floatValue);
        } else {
            // Fallback on earlier versions
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(YES, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(YES, nil, error);
    }];
}

+ (void)_post:(NSString *)url
    paraments:(NSDictionary *)paraments
   completion:(LZNetManagerBlock)completion
{
    [[[self sharedInstance] httpManager] POST:url parameters:paraments headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        if (@available(iOS 11.0, *)) {
            LZLoggerInfo(@"完成：%.2f", uploadProgress.fileCompletedCount.floatValue / uploadProgress.fileTotalCount.floatValue);
        } else {
            // Fallback on earlier versions
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(YES, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(YES, nil, error);
    }];
}

@end

@implementation LZNetManager (NetStatus)

- (void)startMonitoring {
    @lz_weakify(self)
    [self.netStatusManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @lz_strongify(self)
        LZLoggerInfo(@"----当前网络状态---%zd", status);
        [self _netDidChanged:status];
    }];
    [self.netStatusManager startMonitoring];
}

- (void)stopMonitoring {
    [self.netStatusManager stopMonitoring];
}

- (int)observerCount { return (int)self.observers.count; }

- (void)addObserver:(id<LZNetStatusDelegate>)observer {
    [self.gcd async:^{
        [self.observers addObject:observer];
    }];
}

- (void)removeObserver:(id<LZNetStatusDelegate>)observer {
    [self.gcd async:^{
        [self.observers removeObject:observer];
    }];
}

- (LZNetStatus)getNetStatus { return (LZNetStatus)self.netStatusManager.networkReachabilityStatus; }

// MARK: - Priv

- (void)_netDidChanged:(AFNetworkReachabilityStatus)status {
    [self.gcd async:^{
        for (id<LZNetStatusDelegate>observer in self.observers.allObjects) {
            if ([observer respondsToSelector:@selector(netStatusDidChanged:)]) {
                [observer netStatusDidChanged:(LZNetStatus)status];
            }
        }
    }];
}

@end

#import <ifaddrs.h>
#import <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#import <dlfcn.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#import <SystemConfiguration/CaptiveNetwork.h>
@implementation LZNetManager (Common)

+ (nullable NSString *)getCurrentLocalIP {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
