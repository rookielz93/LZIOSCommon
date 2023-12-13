//
//  FMResultSet+Parser.h
//  VideoDownloader
//
//  Created by lz on 2023/9/16.
//

#import "FMResultSet.h"

NS_ASSUME_NONNULL_BEGIN

@class FMResultSet;
@class LZSqlChain;
@interface FMResultSet (Parser)

- (NSArray *)parseWithChain:(LZSqlChain *)chain;

@end

NS_ASSUME_NONNULL_END
