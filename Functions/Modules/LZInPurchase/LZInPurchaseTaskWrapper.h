//
//  LZInPurchaseTaskWrapper.h
//  VideoDownloader
//
//  Created by lz on 2023/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZInPurchaseTaskWrapper : NSObject

- (instancetype)initWithTask:(id)task completion:(id)completion;

@property (nonatomic, strong) id task;
@property (nonatomic, copy)   id completion;

@end

NS_ASSUME_NONNULL_END
