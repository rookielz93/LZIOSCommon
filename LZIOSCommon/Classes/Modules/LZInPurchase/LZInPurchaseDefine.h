//
//  LZInPurchaseDefine.h
//  VideoDownloader
//
//  Created by lz on 2023/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : int {
    LZInPurchaseReceiptServerStatusCodeSandbox = 21007,
} LZInPurchaseReceiptServerStatusCode;

typedef NSString* LZInPurchaseReceiptServerString;
extern LZInPurchaseReceiptServerString LZInPurchaseReceiptServerStringOnline;
extern LZInPurchaseReceiptServerString LZInPurchaseReceiptServerStringTest;

typedef NSString* LZInPurchaseProductIden;
extern LZInPurchaseProductIden LZInPurchaseProductIdenPermanent;
extern LZInPurchaseProductIden LZInPurchaseProductIdenWeek;
extern LZInPurchaseProductIden LZInPurchaseProductIdenWeekFreeTrial3;

typedef NSString* LZInPurchasePersistenceKey;
extern LZInPurchasePersistenceKey LZInPurchasePersistenceKeyProducts;
extern LZInPurchasePersistenceKey LZInPurchasePersistenceKeyVIP;

extern NSString* LZInPurchasePassword;

@class LZInPurchaseProduct;
@class LZInPurchaseReceiptResponse;
typedef void (^LZInPurchaseRequestCompletion) (NSDictionary <LZInPurchaseProductIden, LZInPurchaseProduct*>* _Nullable response, NSError * _Nullable error);
typedef void (^LZInPurchasePayCompletion)     (LZInPurchaseProductIden iden, NSError * _Nullable error);
typedef void (^LZInPurchaseRestoreCompletion) (NSSet<LZInPurchaseProductIden> *idens, NSError * _Nullable error);
typedef void (^LZInPurchaseCheckReceiptCompletion) (LZInPurchaseReceiptResponse * _Nullable response, NSError * _Nullable error);

@interface LZInPurchaseDefine : NSObject

@end

NS_ASSUME_NONNULL_END
