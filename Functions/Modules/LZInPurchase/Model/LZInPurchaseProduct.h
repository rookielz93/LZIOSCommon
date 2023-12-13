//
//  LZInPurchaseProduct.h
//  VideoDownloader
//
//  Created by 金胜利 on 2023/12/5.
//

#import <Foundation/Foundation.h>
#import "LZInPurchaseDefine.h"

NS_ASSUME_NONNULL_BEGIN

@class SKProduct;
@interface LZInPurchaseProduct : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSString *localizedDescription;

@property (nonatomic, copy, readonly) NSString *localizedTitle;

@property (nonatomic, copy, readonly) NSDecimalNumber *price;

@property (nonatomic, copy, readonly) NSLocale *priceLocale;

@property (nonatomic, copy, readonly) LZInPurchaseProductIden productIdentifier;

@property (nonatomic, copy, readonly) NSString *localizedPrice;

- (LZInPurchaseProduct *)initWithProduct:(SKProduct *)product;

@end

NS_ASSUME_NONNULL_END
