//
//  LZSqlCondition.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/13.
//

#import "LZSqlCondition.h"
#import "LZSqlChain.h"

@implementation LZSqlCondition

+ (instancetype)conWithChain:(LZSqlChain *)chain type:(LZSqlConditionType)type {
    LZSqlCondition *con = [[LZSqlCondition alloc] initWithChain:chain type:type];
    return con;
}

- (instancetype)initWithChain:(LZSqlChain *)chain type:(LZSqlConditionType)type {
    if (self = [super init]) {
        _chain = chain;
        _type = type;
    }
    return self;
}

- (LZSqlCondition * _Nonnull (^)(NSString * _Nonnull))key {
    return ^LZSqlCondition *(NSString *key) {
        self->_propName = key;
        return self;
    };
}

- (LZSqlChain *(^)(id param))eq {
    return ^LZSqlChain *(id param) {
        self->_param = param;
        self->_opr = LZSqlConditionOperator_Equal;
        return self.chain;
    };
}

- (LZSqlChain *(^)(id param))nq  {
    return ^LZSqlChain *(id param) {
        self->_param = param;
        self->_opr = LZSqlConditionOperator_NotEqual;
        return self.chain;
    };
}

- (LZSqlChain *(^)(id param))like {
    return ^LZSqlChain *(id param) {
        self->_param = param;
        self->_opr = LZSqlConditionOperator_Like;
        return self.chain;
    };
}

- (LZSqlChain * _Nonnull (^)(id _Nonnull))gt {
    return ^LZSqlChain *(id param) {
        self->_param = param;
        self->_opr = LZSqlConditionOperator_GreaterThan;
        return self.chain;
    };
}

- (LZSqlChain * _Nonnull (^)(id _Nonnull))gtOrEq {
    return ^LZSqlChain *(id param) {
        self->_param = param;
        self->_opr = LZSqlConditionOperator_GreaterThanOrEqual;
        return self.chain;
    };
}

- (LZSqlChain * _Nonnull (^)(id _Nonnull))lt {
    return ^LZSqlChain *(id param) {
        self->_param = param;
        self->_opr = LZSqlConditionOperator_LessThan;
        return self.chain;
    };
}

- (LZSqlChain * _Nonnull (^)(id _Nonnull))ltOrEq {
    return ^LZSqlChain *(id param) {
        self->_param = param;
        self->_opr = LZSqlConditionOperator_LessThanOrEqual;
        return self.chain;
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@, %@, %@",
            [LZSqlDefine descForConditionType:self.type],
            [LZSqlDefine descForConditionOperator:self.opr],
            self.propName,
            self.param];
}

@end
