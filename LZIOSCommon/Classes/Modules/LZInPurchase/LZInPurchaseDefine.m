//
//  LZInPurchaseDefine.m
//  VideoDownloader
//
//  Created by lz on 2023/9/23.
//

#import "LZInPurchaseDefine.h"

LZInPurchaseReceiptServerString LZInPurchaseReceiptServerStringOnline = @"https://buy.itunes.apple.com/verifyReceipt";
LZInPurchaseReceiptServerString LZInPurchaseReceiptServerStringTest = @"https://sandbox.itunes.apple.com/verifyReceipt";

LZInPurchaseProductIden LZInPurchaseProductIdenPermanent = @"com.Repost.insave.instant.save.video.lifetime";
LZInPurchaseProductIden LZInPurchaseProductIdenWeek = @"com.Repost.insave.instant.save.video.week";
LZInPurchaseProductIden LZInPurchaseProductIdenWeekFreeTrial3 = @"com.Repost.insave.instant.save.video.week_3";

LZInPurchasePersistenceKey LZInPurchasePersistenceKeyProducts = @"lz_in_purchase_products";
LZInPurchasePersistenceKey LZInPurchasePersistenceKeyVIP = @"lz_in_purchase_is_vip";
LZInPurchasePersistenceKey LZInPurchasePersistenceKeyPassword = @"lz_in_purchase_password";

NSString* LZInPurchasePassword = @"84ffce0f9c33423993338dbc7f0785a7";
//@"40de8fe21a314ad8a064fed625350787";

@implementation LZInPurchaseDefine

@end
