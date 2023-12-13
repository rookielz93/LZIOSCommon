//
//  LZSqlChain.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/13.
//

#import "LZSqlChain.h"
#import "LZSqlCondition.h"
#import "NSObject+LZRuntime.h"

@interface LZSqlChain ()

@property (nonatomic, readwrite, strong) Class<LZSqlModelProtocol> targetClazz;
@property (nonatomic, readwrite, strong) NSArray <id<LZSqlModelProtocol>> *targets;
@property (nonatomic, strong) NSMutableArray <LZSqlCondition *> *conds;

@end

@implementation LZSqlChain

- (instancetype)initWithType:(LZSqlChainType)type {
    return [self initWithSqlName:nil type:type];
}

- (instancetype)initWithSqlName:(NSString *)sqlName type:(LZSqlChainType)type {
    if (self = [super init]) {
        _sqlName = sqlName.copy;
        _type = type;
    }
    return self;
}

// MARK: - Public

- (NSArray<LZSqlCondition *> *)conditions { return self.conds.copy; }

+ (LZSqlChainClassAction)CreateTable {
    return [self _GenClazzAction:LZSqlChainTypeCreateTable];
}

+ (LZSqlChainClassAction)DropTable {
    return [self _GenClazzAction:LZSqlChainTypeDropTable];
}

+ (LZSqlChainClassAction)UpdateTable {
    return [self _GenClazzAction:LZSqlChainTypeUpdateTable];
}

+ (LZSqlChainClassAction)TableExists {
    return [self _GenClazzAction:LZSqlChainTypeTableExists];
}

+ (LZSqlChainClassAction)TableColumnNames {
    return [self _GenClazzAction:LZSqlChainTypeTableColumnNames];
}

+ (LZSqlChainArrayAction)Insert {
    return [self _GenArrayAction:LZSqlChainTypeInsert];
}

+ (LZSqlChainArrayAction)Update {
    return [self _GenArrayAction:LZSqlChainTypeUpdate];
}

+ (LZSqlChainArrayAction)Remove {
    return [self _GenArrayAction:LZSqlChainTypeRemove];
}

+ (LZSqlChainClassAction)RemoveAll {
    return [self _GenClazzAction:LZSqlChainTypeRemoveAll];
}

+ (LZSqlChainClassAction)Select {
    return [self _GenClazzAction:LZSqlChainTypeSelect];
}

+ (LZSqlChainClassAction)SelectAll {
    return [self _GenClazzAction:LZSqlChainTypeSelectAll];
}

- (LZSqlCondition *(^)(NSString *propName))And {
    LZSqlCondition *cond = [LZSqlCondition conWithChain:self type:LZSqlConditionType_And];
    [self.conds addObject:cond];
    return cond.key;
}

- (LZSqlCondition *(^)(NSString *propName))Or {
    LZSqlCondition *cond = [LZSqlCondition conWithChain:self type:LZSqlConditionType_Or];
    [self.conds addObject:cond];
    return cond.key;
}

// MARK: - Priv

+ (LZSqlChainArrayAction)_GenArrayAction:(LZSqlChainType)type {
    return ^(NSArray <id<LZSqlModelProtocol>> *models) {
        LZSqlChain *chain = nil;
        if (!models || ![models isKindOfClass:[NSArray class]] || models.count==0) {
            return chain;
        }
        
        chain = [[LZSqlChain alloc] initWithType:type];
        chain.targets = models;
        chain.targetClazz = models[0].class;
        return chain;
    };
}

+ (LZSqlChainClassAction)_GenClazzAction:(LZSqlChainType)type {
    return ^(Class clazz) {
        LZSqlChain *chain = nil;
        if (!clazz) {
            return chain;
        }
        
        chain = [[LZSqlChain alloc] initWithType:type];
        chain.targetClazz = clazz;
        return chain;
    };
}

// MARK: - Props

- (NSMutableArray<LZSqlCondition *> *)conds {
    if (!_conds) _conds = @[].mutableCopy;
    return _conds;
}

- (NSString *)description {
    NSMutableString *ret = [NSString stringWithFormat:@"%@, targetClass: %@, targets: %@, conditions: ",
                            [LZSqlDefine descForChainType:_type],
                            [[self.targetClazz class] lz_className],
                            self.targets].mutableCopy;
    if (_conds && _conds.count>0) {
        for (LZSqlCondition *cond in _conds) {
            [ret appendString:cond.description];
        }
    } else {
        [ret appendString:@"(null)"];
    }
    return ret.copy;
}

@end

#import "LZSqlTool.h"
@implementation LZSqlChain (Execute)

- (LZSqlResult *)_Execute {
    return [[LZSqlTool sharedInstance] executeChain:self];
}

- (LZSqlResult *)Execute {
    if (self.type < LZSqlChainTypeCreateTable) {
        LZSqlCreateTable2(self.targetClazz)._Execute;
    }
    return [self _Execute];
}

@end
