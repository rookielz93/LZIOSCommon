//
//  LZInPurchaseManager.h
//  VideoDownloader
//
//  Created by lz on 2023/9/23.
//

#import <Foundation/Foundation.h>
#import "LZSingleton.h"
#import "LZInPurchaseDefine.h"

NS_ASSUME_NONNULL_BEGIN
/*
 参考：
 https://juejin.cn/post/6844903874365489165
 https://www.jianshu.com/p/2247f3b36be3
 */

@protocol LZInPurchaseManagerDelegate <NSObject>



@end

@interface LZInPurchaseManager : NSObject
LZSingletonH

- (void)requestProducts:(NSSet<LZInPurchaseProductIden>*)idens completion:(LZInPurchaseRequestCompletion)completion;

- (void)requestAllProductsAndSave:(nullable LZInPurchaseRequestCompletion)completion;

- (void)payProduct:(LZInPurchaseProductIden)iden completion:(LZInPurchasePayCompletion)completion;

- (void)restore:(LZInPurchaseRestoreCompletion)completion;

- (void)checkReceipt:(nullable LZInPurchaseCheckReceiptCompletion)completion; // 检查商品已购的商品有效性

@end

@interface LZInPurchaseManager (VIP)

- (NSSet<LZInPurchaseProductIden> *)vipIdens;

- (BOOL)isVIP;

@end

NS_ASSUME_NONNULL_END
