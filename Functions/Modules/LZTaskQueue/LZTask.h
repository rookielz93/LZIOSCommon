//
//  LZTask.h
//  AMMobileFoundation-AMSecurityPolicy
//
//  Created by 金胜利 on 2023/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZTask : NSObject

@property (nonatomic, readonly, strong) id result;
@property (nonatomic, readonly, strong) NSError *error;

- (void)cancel; // 外部可以使用，进行cancel

@end

NS_ASSUME_NONNULL_END
