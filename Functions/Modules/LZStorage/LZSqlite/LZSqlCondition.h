//
//  LZSqlCondition.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/13.
//

#import <Foundation/Foundation.h>
#import "LZSqlDefine.h"

NS_ASSUME_NONNULL_BEGIN

@class LZSqlChain;
@interface LZSqlCondition : NSObject

@property (nonatomic, readonly, weak) LZSqlChain *chain;

@property (nonatomic, readonly, assign) LZSqlConditionType type;
@property (nonatomic, readonly, assign) LZSqlConditionOperator opr;

@property (nonatomic, readonly, strong) NSString *propName;
@property (nonatomic, readonly, strong) id param;

+ (instancetype)conWithChain:(LZSqlChain *)chain type:(LZSqlConditionType)type;

- (LZSqlCondition * _Nonnull (^)(NSString * _Nonnull))key;

- (LZSqlChain *(^)(id param))eq;

- (LZSqlChain *(^)(id param))nq;

- (LZSqlChain *(^)(id param))like;

- (LZSqlChain * _Nonnull (^)(id _Nonnull))gt;

- (LZSqlChain * _Nonnull (^)(id _Nonnull))gtOrEq;

- (LZSqlChain * _Nonnull (^)(id _Nonnull))lt;

- (LZSqlChain * _Nonnull (^)(id _Nonnull))ltOrEq;

@end

NS_ASSUME_NONNULL_END
