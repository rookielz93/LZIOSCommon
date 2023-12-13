//
//  LZInPurchaseReceipt.m
//  VideoDownloader
//
//  Created by lz on 2023/9/24.
//

#import "LZInPurchaseReceipt.h"

@implementation LZInPurchaseReceiptResponse
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"receipt" : LZInPurchaseReceiptModel.class,
              @"latest_receipt_info" : LZInPurchaseReceiptProduct2.class
    };
}
@end

@implementation LZInPurchaseReceiptModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"in_app" : LZInPurchaseReceiptProduct1.class };
}
@end

@implementation LZInPurchaseReceiptProduct1
@end
@implementation LZInPurchaseReceiptProduct2
@end
