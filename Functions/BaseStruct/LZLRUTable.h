//
//  LZLRUTable.h
//  TestProject
//
//  Created by 金胜利 on 2023/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZLRUNode : NSObject

@property (nonatomic, readonly, copy)   NSString *key;
@property (nonatomic, readonly, strong) id value;

@end

@interface LZLRUTable : NSObject

@property (nonatomic, readonly, assign) int count;

- (BOOL)add:(id)value;
- (nullable LZLRUNode *)remove:(id)value;
- (nullable LZLRUNode *)getLRUNodeWithValue:(id)value;

- (BOOL)add:(id)value forKey:(NSString *)key;
- (nullable LZLRUNode *)removeValueForKey:(NSString *)key;
- (nullable LZLRUNode *)getLRUNodeWithKey:(NSString *)key;

- (nullable LZLRUNode *)removeLast;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
