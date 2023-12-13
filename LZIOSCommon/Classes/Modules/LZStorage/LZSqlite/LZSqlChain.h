//
//  LZSqlChain.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/13.
//

#import <Foundation/Foundation.h>
#import "LZSqlModelProtocol.h"
#import "LZSqlDefine.h"

NS_ASSUME_NONNULL_BEGIN

// chain
@class LZSqlChain;
typedef LZSqlChain* _Nullable (^LZSqlChainArrayAction) (NSArray <id<LZSqlModelProtocol>> *models);
typedef LZSqlChain* _Nullable (^LZSqlChainClassAction) (Class<LZSqlModelProtocol> model);
// condition
@class LZSqlCondition;
typedef LZSqlCondition* _Nullable (^LZSqlConditionKeyAction) (NSString *propName);

@interface LZSqlChain<T:id<LZSqlModelProtocol>> : NSObject

@property (nonatomic, readonly, copy)   NSString *sqlName; // nil is default 
@property (nonatomic, readonly, assign) LZSqlChainType type;
@property (nonatomic, readonly, strong) Class<LZSqlModelProtocol> targetClazz;
@property (nonatomic, readonly, strong) NSArray<id<LZSqlModelProtocol>> *targets;
@property (nonatomic, readonly, strong) NSArray<id<LZSqlModelProtocol>> *conditions;

- (instancetype)initWithType:(LZSqlChainType)type;
- (instancetype)initWithSqlName:(nullable NSString *)sqlName type:(LZSqlChainType)type;

+ (LZSqlChainClassAction)CreateTable;
+ (LZSqlChainClassAction)DropTable;
+ (LZSqlChainClassAction)UpdateTable;
+ (LZSqlChainClassAction)TableExists;
+ (LZSqlChainClassAction)TableColumnNames;
+ (LZSqlChainArrayAction)Insert;
+ (LZSqlChainArrayAction)Update;
+ (LZSqlChainArrayAction)Remove;
+ (LZSqlChainClassAction)RemoveAll;
+ (LZSqlChainClassAction)Select;
+ (LZSqlChainClassAction)SelectAll;

- (LZSqlConditionKeyAction)And;
- (LZSqlConditionKeyAction)Or;

@end

@class LZSqlResult;
@interface LZSqlChain (Execute)

- (LZSqlResult *)Execute;

@end

NS_ASSUME_NONNULL_END
