//
//  LZTaskConfig.h
//  LZ-kit
//
//  Created by 金胜利 on 2023/9/19.
//

#import <Foundation/Foundation.h>
#import "LZTaskProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZTaskConfig : NSObject

- (instancetype)initWithSource:(nullable id)source
                       excuter:(nullable id<LZTaskExecuterProtocol>)executer
            executerCompletion:(LZTaskCompletion)completion;

@property (nonatomic, strong, nullable) id source;
@property (nonatomic, strong, nullable) id<LZTaskExecuterProtocol> executer;
@property (nonatomic, copy,   nullable) LZTaskCompletion completion;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
