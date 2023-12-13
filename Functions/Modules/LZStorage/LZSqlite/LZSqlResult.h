//
//  LZSqlResult.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZSqlResult : NSObject

+ (instancetype)success;
+ (instancetype)failed;

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSArray *result;

@end

NS_ASSUME_NONNULL_END
