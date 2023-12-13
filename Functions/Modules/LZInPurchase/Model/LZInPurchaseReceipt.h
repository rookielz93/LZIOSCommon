//
//  LZInPurchaseReceipt.h
//  VideoDownloader
//
//  Created by lz on 2023/9/24.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LZInPurchaseReceiptModel;
@class LZInPurchaseReceiptProduct2;
@interface LZInPurchaseReceiptResponse : NSObject

@property (nonatomic, strong) LZInPurchaseReceiptModel *receipt;
@property (nonatomic, strong) NSArray <LZInPurchaseReceiptProduct2 *>*latest_receipt_info;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *environment;

@end

@class LZInPurchaseReceiptProduct1;
@interface LZInPurchaseReceiptModel : NSObject

@property (nonatomic, strong) NSString *receipt_type;
@property (nonatomic, strong) NSNumber *adam_id;
@property (nonatomic, strong) NSNumber *app_item_id;
@property (nonatomic, strong) NSString *bundle_id;
@property (nonatomic, strong) NSString *application_version;
@property (nonatomic, strong) NSNumber *download_id;
@property (nonatomic, strong) NSNumber *version_external_identifier;
@property (nonatomic, strong) NSString *receipt_creation_date;
@property (nonatomic, strong) NSString *receipt_creation_date_ms;
@property (nonatomic, strong) NSString *receipt_creation_date_pst;
@property (nonatomic, strong) NSString *request_date;
@property (nonatomic, strong) NSString *request_date_ms;
@property (nonatomic, strong) NSString *request_date_pst;
@property (nonatomic, strong) NSString *original_purchase_date;
@property (nonatomic, strong) NSString *original_purchase_date_ms;
@property (nonatomic, strong) NSString *original_purchase_date_pst;
@property (nonatomic, strong) NSString *original_application_version;
@property (nonatomic, strong) NSArray <LZInPurchaseReceiptProduct1 *>*in_app;

@end

@interface LZInPurchaseReceiptProduct1 : NSObject // 消耗品 或 非订阅

@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *transaction_id;
@property (nonatomic, strong) NSString *original_transaction_id;
@property (nonatomic, strong) NSString *purchase_date;
@property (nonatomic, strong) NSString *purchase_date_ms;
@property (nonatomic, strong) NSString *purchase_date_pst;
@property (nonatomic, strong) NSString *expires_date_ms;
@property (nonatomic, strong) NSString *original_purchase_date;
@property (nonatomic, strong) NSString *original_purchase_date_ms;
@property (nonatomic, strong) NSString *original_purchase_date_pst;
@property (nonatomic, assign) BOOL is_trial_period;

@end

@interface LZInPurchaseReceiptProduct2 : NSObject // 订阅

@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *transaction_id;
@property (nonatomic, strong) NSString *original_transaction_id;
@property (nonatomic, strong) NSString *purchase_date;
@property (nonatomic, strong) NSString *purchase_date_ms;
@property (nonatomic, strong) NSString *purchase_date_pst;
@property (nonatomic, strong) NSString *original_purchase_date;
@property (nonatomic, strong) NSString *original_purchase_date_ms;
@property (nonatomic, strong) NSString *original_purchase_date_pst;
@property (nonatomic, strong) NSString *expires_date; // 美国时间
@property (nonatomic, strong) NSString *expires_date_ms;
@property (nonatomic, strong) NSString *expires_date_pst;
@property (nonatomic, strong) NSString *web_order_line_item_id;
@property (nonatomic, strong) NSString *is_trial_period;
@property (nonatomic, strong) NSString *is_in_intro_offer_period;
@property (nonatomic, strong) NSString *in_app_ownership_type;
@property (nonatomic, strong) NSString *subscription_group_identifier;

@end


NS_ASSUME_NONNULL_END

/*
 {
   "receipt": {
     "receipt_type": "ProductionSandbox",
     "adam_id": 0,
     "app_item_id": 0,
     "bundle_id": "com.Yo***ights",
     "application_version": "1",
     "download_id": 0,
     "version_external_identifier": 0,
     "receipt_creation_date": "2020-06-01 09:37:57 Etc/GMT",
     "receipt_creation_date_ms": "1591004277000",
     "receipt_creation_date_pst": "2020-06-01 02:37:57 America/Los_Angeles",
     "request_date": "2020-06-01 09:38:55 Etc/GMT",
     "request_date_ms": "1591004335844",
     "request_date_pst": "2020-06-01 02:38:55 America/Los_Angeles",
     "original_purchase_date": "2013-08-01 07:00:00 Etc/GMT",
     "original_purchase_date_ms": "1375340400000",
     "original_purchase_date_pst": "2013-08-01 00:00:00 America/Los_Angeles",
     "original_application_version": "1.0",
     "in_app": [
       {
         "quantity": "1",
         "product_id": "com.yo***thlycard",
         "transaction_id": "10***4780",
         "original_transaction_id": "10***4780",
         "purchase_date": "2020-06-01 09:36:56 Etc/GMT",
         "purchase_date_ms": "1591004216000",
         "purchase_date_pst": "2020-06-01 02:36:56 America/Los_Angeles",
         "original_purchase_date": "2020-06-01 09:36:56 Etc/GMT",
         "original_purchase_date_ms": "1591004216000",
         "original_purchase_date_pst": "2020-06-01 02:36:56 America/Los_Angeles",
         "is_trial_period": "false"
       },
       {
         "quantity": "1",
         "product_id": "com.yo***iteprime1",
         "transaction_id": "10***3950",
         "original_transaction_id": "10***3950",
         "purchase_date": "2020-06-01 09:35:30 Etc/GMT",
         "purchase_date_ms": "1591004130000",
         "purchase_date_pst": "2020-06-01 02:35:30 America/Los_Angeles",
         "original_purchase_date": "2020-06-01 09:35:30 Etc/GMT",
         "original_purchase_date_ms": "1591004130000",
         "original_purchase_date_pst": "2020-06-01 02:35:30 America/Los_Angeles",
         "is_trial_period": "false"
       }
     ]
   },
   "latest_receipt_info": [
     {
         "quantity": "1",
         "product_id": "产品Id",         /// 产品Id
         "transaction_id": "1000000850764418",
         "original_transaction_id": "1000000850764418",         /// 此id值不变
         "purchase_date": "2021-07-30 03:13:27 Etc/GMT",     ///最新的购买时间
         "purchase_date_ms": "1627614807000",             ///最新的购买时间毫秒
         "purchase_date_pst": "2021-07-29 20:13:27 America/Los_Angeles",     ///最新的购买时间（太平洋的时间）
         "original_purchase_date": "2021-07-30 03:13:29 Etc/GMT",             ///最初的购买时间
         "original_purchase_date_ms": "1627614809000",                 ///最初的购买时间毫秒
         "original_purchase_date_pst": "2021-07-29 20:13:29 America/Los_Angeles",     /// 最初的购买时间（太平洋的时间）
         "expires_date": "2021-07-30 03:18:27 Etc/GMT",              /// 时间到期
         "expires_date_ms": "1627615107000",                         ///到期时间毫秒
         "expires_date_pst": "2021-07-29 20:18:27 America/Los_Angeles", /        //到期时间（太平洋的时间）
         "web_order_line_item_id": "1000000064562233",
         "is_trial_period": "false",                                 ///  首次购买
         "is_in_intro_offer_period": "false",                         ///  是否是否是在试用期
         "in_app_ownership_type": "PURCHASED",
         "subscription_group_identifier": "20857364"
     }
   ],
   "status": 0,
   "environment": "Sandbox"
 }
 */
