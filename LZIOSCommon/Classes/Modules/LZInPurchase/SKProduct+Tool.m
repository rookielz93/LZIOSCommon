//
//  SKProduct+Tool.m
//  VideoDownloader
//
//  Created by lz on 2023/11/29.
//

#import "SKProduct+Tool.h"

@implementation SKProduct (Tool)

- (NSString *)localizedPrice {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.locale = self.priceLocale;
    return [formatter stringFromNumber:self.price];
}

@end
