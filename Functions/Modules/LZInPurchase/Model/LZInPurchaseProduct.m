//
//  LZInPurchaseProduct.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/12/5.
//

#import "LZInPurchaseProduct.h"
#import <StoreKit/StoreKit.h>

@implementation LZInPurchaseProduct

- (LZInPurchaseProduct *)initWithProduct:(SKProduct *)product {
    if (self = [super init]) {
        _localizedDescription = product.localizedDescription;
        _localizedTitle = product.localizedTitle;
        _price = product.price;
        _priceLocale = product.priceLocale;
        _productIdentifier = product.productIdentifier;
    }
    return self;
}

- (NSString *)localizedPrice {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.locale = self.priceLocale;
    return [formatter stringFromNumber:self.price];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.localizedDescription forKey:@"localizedDescription"];
    [aCoder encodeObject:self.localizedTitle forKey:@"localizedTitle"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.priceLocale forKey:@"priceLocale"];
    [aCoder encodeObject:self.productIdentifier forKey:@"productIdentifier"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _localizedDescription = [aDecoder decodeObjectForKey:@"localizedDescription"];
        _localizedTitle = [aDecoder decodeObjectForKey:@"localizedTitle"];
        _price = [aDecoder decodeObjectForKey:@"price"];
        _priceLocale = [aDecoder decodeObjectForKey:@"priceLocale"];
        _productIdentifier = [aDecoder decodeObjectForKey:@"productIdentifier"];
    }
    return self;
}

@end
