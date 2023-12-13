//
//  LZSqlChainParser.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/14.
//

#import <Foundation/Foundation.h>
#import "LZSqlDefine.h"

NS_ASSUME_NONNULL_BEGIN
    
@interface LZSqlCMD : NSObject

@property (nonatomic, assign) LZSqlCMDType type;
@property (nonatomic, strong) NSString *cmd;
@property (nonatomic, strong) NSArray *args;

@end

@class LZSqlChain;
@interface LZSqlChainParser : NSObject

+ (LZSqlCMD *)parse:(LZSqlChain *)chain;

@end

NS_ASSUME_NONNULL_END
