//
//  LZInPurchaseManager.m
//  VideoDownloader
//
//  Created by lz on 2023/9/23.
//

#import "LZInPurchaseManager.h"
#import <StoreKit/StoreKit.h>
#import "LZGCD.h"
#import "LZLog.h"
#import "LZError.h"
#import "NSObject+LZRuntime.h"
#import "LZInPurchaseTaskWrapper.h"
#import "LZInPurchaseReceipt.h"
#import <YYModel/YYModel.h>
#import "LZUserDefault.h"
#import "LZInPurchaseProduct.h"

@interface LZInPurchaseManager ()

@property (nonatomic, strong) LZGCD *safe;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) NSMutableDictionary <NSString *, LZInPurchaseTaskWrapper *> *requestMap;
@property (nonatomic, strong) NSMutableDictionary <NSString *, LZInPurchaseTaskWrapper *> *payMap;
@property (nonatomic, copy)   NSMutableArray <LZInPurchaseRestoreCompletion> *restoreCompletions;
@property (nonatomic, assign) BOOL noNeedUpdateReceiptInfos;
@property (nonatomic, strong) LZInPurchaseReceiptResponse *recepitInfos;
@property (nonatomic, assign) BOOL noNeedUpdateProductInfos;
@property (nonatomic, strong) NSDictionary <LZInPurchaseProductIden, LZInPurchaseProduct *>*products;

@end

@interface LZInPurchaseManager (ProductInfoRequest) <SKProductsRequestDelegate>
- (void)_saveProducts:(NSDictionary <LZInPurchaseProductIden, LZInPurchaseProduct *>*)products;
- (NSDictionary <LZInPurchaseProductIden, LZInPurchaseProduct *>*)_getProducts;
- (NSDictionary <LZInPurchaseProductIden, LZInPurchaseProduct *>*)_getProducts:(NSSet <LZInPurchaseProductIden>*)idens;
- (void)_requestProduct:(id)idens completion:(LZInPurchaseRequestCompletion)completion;
@end

@interface LZInPurchaseManager (ProductPay) <SKPaymentTransactionObserver>
- (void)_payProduct:(LZInPurchaseProductIden)iden completion:(LZInPurchasePayCompletion)completion;
- (void)_restore:(NSObject *)completion; // 这里由于限制问题，将 LZInPurchaseRestoreCompletion 改成了 NSObject *
@end

@interface LZInPurchaseManager (CheckReceipt)
- (void)_checkReceipt:(BOOL)online completion:(LZInPurchaseCheckReceiptCompletion)completion;
@end

@interface LZInPurchaseManager (VIP)
- (void)_saveVIPStatusWithIdens:(NSSet <LZInPurchaseProductIden>*)idens;
@end

@implementation LZInPurchaseManager
LZSingletonM

- (void)_setup {
    _safe = [[LZGCD alloc] initWithName:@"com.lz.in.purchase.safe.queue"];
    _requestMap = @{}.mutableCopy;
    _payMap = @{}.mutableCopy;
    _restoreCompletions = @[].mutableCopy;
    _products = [self _getProducts];
    _noNeedUpdateReceiptInfos = NO;
    _noNeedUpdateProductInfos = NO;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

// MARK: - Public

- (void)launchWithOption:(NSDictionary *)options {
    self.password = options[LZInPurchasePersistenceKeyPassword];
    NSAssert(self.password, @"in purchase'password is nil");
}

- (void)requestProducts:(NSSet<NSString *> *)idens completion:(nonnull LZInPurchaseRequestCompletion)completion {
    [self.safe async:^{
        if (self.products) {
            LZLoggerInfo(@"has products %d, return", self.noNeedUpdateProductInfos);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([self _getProducts:idens], nil);
            });
            return;
        }
        [self _requestProduct:idens completion:completion];
    }];
}

- (void)requestAllProductsAndSave:(LZInPurchaseRequestCompletion)completion {
    if (self.noNeedUpdateProductInfos) {
        if (completion) completion(self.products, nil);
        return;
    }
    
    [self.safe async:^{
        [self _requestProduct:[self vipIdens] completion:^(NSDictionary<LZInPurchaseProductIden, LZInPurchaseProduct *> * _Nullable response, NSError * _Nullable error) {
            if (error) {
                LZLoggerInfo(@"%@", error);
                return;
            }
            
            if (self.noNeedUpdateProductInfos) {
                return;
            }
            
            NSSet *responseSet = [NSSet setWithArray:response.allKeys];
            self.noNeedUpdateProductInfos = [responseSet isEqualToSet:[self vipIdens]];
            if (self.noNeedUpdateProductInfos) {
                [self _saveProducts:response];
                self.products = response;
            }
            
            if (completion) completion(response, nil);
        }];
    }];
}

- (void)payProduct:(LZInPurchaseProductIden)iden completion:(LZInPurchasePayCompletion)completion {
    [self.safe async:^{
        [self _payProduct:iden completion:completion];
    }];
}

- (void)restore:(LZInPurchaseRestoreCompletion)completion {
    [self.safe async:^{
        [self _restore:completion];
    }];
}

- (void)checkReceipt:(LZInPurchaseCheckReceiptCompletion)completion {
    LZInPurchaseCheckReceiptCompletion internalCompletion = ^(LZInPurchaseReceiptResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(response, error);
            }
        });
    };
    
    [self.safe async:^{
        if (self.noNeedUpdateReceiptInfos) {
            LZLoggerInfo(@"no need update receipt infos, return");
            internalCompletion(self.recepitInfos, nil);
            return;
        }
        
        // if (status && [status intValue] == LZInPurchaseReceiptServerStatusCodeSandbox) {
        [self _checkReceipt:YES completion:^(LZInPurchaseReceiptResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                internalCompletion(nil, error);
            } else {
                if (response.status.intValue == LZInPurchaseReceiptServerStatusCodeSandbox) {
                    [self _checkReceipt:NO completion:internalCompletion];
                } else {
                    internalCompletion(response, nil);
                }
            }
        }];
    }];
}

@end

@implementation LZInPurchaseManager (ProductInfoRequest)

- (void)_saveProducts:(NSDictionary <LZInPurchaseProductIden, LZInPurchaseProduct *>*)products {
    NSMutableDictionary *productWrappers = @{}.mutableCopy;
    for (LZInPurchaseProductIden iden in products) {
        productWrappers[iden] = [NSKeyedArchiver archivedDataWithRootObject:products[iden]];
    }
    [LZUserDefault saveValue:productWrappers key:LZInPurchasePersistenceKeyProducts];
}

- (NSDictionary <LZInPurchaseProductIden, LZInPurchaseProduct *>*)_getProducts {
    NSDictionary *productWrappers = [LZUserDefault getValueWithKey:LZInPurchasePersistenceKeyProducts];
    if (!productWrappers) {
        return nil;
    }
    NSMutableDictionary *ret = @{}.mutableCopy;
    for (LZInPurchaseProductIden iden in productWrappers) {
        LZInPurchaseProduct *p = [NSKeyedUnarchiver unarchiveObjectWithData:productWrappers[iden]];
        ret[iden] = p;
    }
    return ret;
}

- (NSDictionary <LZInPurchaseProductIden, LZInPurchaseProduct *>*)_getProducts:(NSSet <LZInPurchaseProductIden>*)idens {
    if (!idens || idens.count == 0) {
        return nil;
    }
    
    NSMutableDictionary *ret = @{}.mutableCopy;
    for (LZInPurchaseProductIden iden in idens) {
        ret[iden] = self.products[iden];
    }
    return ret;
}

- (NSDictionary<LZInPurchaseProductIden, LZInPurchaseProduct *> *)_transformProducts:(SKProductsResponse *)response {
    NSMutableDictionary *ret = @{}.mutableCopy;
    for (SKProduct *product in response.products) {
        ret[product.productIdentifier] = [[LZInPurchaseProduct alloc] initWithProduct:product];
    }
    return ret;
}

- (void)_cancelAllRequests {
    for (LZInPurchaseTaskWrapper *wrapper in self.requestMap.allValues) {
        [(SKRequest *)wrapper.task cancel];
    }
}

- (void)_requestProduct:(NSSet<NSString *> *)idens completion:(LZInPurchaseRequestCompletion)completion {
    [self _cancelAllRequests]; // 同一时间只处理一个
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:idens];
    request.delegate = self;
    LZInPurchaseTaskWrapper *wrapper = [[LZInPurchaseTaskWrapper alloc] initWithTask:request completion:completion];
    self.requestMap[request.lz_uuid] = wrapper;

    [request start];
}

- (void)_requestCallback:(SKRequest *)request response:(SKProductsResponse *)response error:(NSError *)error {
    [self.safe async:^{
        [self __requestCallback:request response:response error:error];
    }];
}

- (void)__requestCallback:(SKRequest *)request response:(SKProductsResponse *)response error:(NSError *)error {
    LZInPurchaseTaskWrapper *wrapper = self.requestMap[request.lz_uuid];
    if (wrapper.completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ((LZInPurchaseRequestCompletion)wrapper.completion)([self _transformProducts:response], error);
        });
        self.requestMap[request.lz_uuid] = nil;
    }
}

// MARK: - SKProductsRequestDelegate

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    LZLoggerInfo(@"%@, %@", request, error);
    [self _requestCallback:request response:nil error:error];
}

- (void)requestDidFinish:(SKRequest *)request {
    LZLoggerInfo(@"%@", request);
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    LZLoggerInfo(@"%@, %@", request, response);
    [self _requestCallback:request response:response error:nil];
}

@end

@implementation LZInPurchaseManager (ProductPay)

- (void)_payProduct:(LZInPurchaseProductIden)iden completion:(LZInPurchasePayCompletion)completion {
    SKMutablePayment *payment = [SKMutablePayment new];
    payment.productIdentifier = iden;
    LZInPurchaseTaskWrapper *wrapper = [[LZInPurchaseTaskWrapper alloc] initWithTask:payment completion:completion];
    self.payMap[payment.lz_uuid] = wrapper;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)_restore:(NSObject *)completion {
    [self.restoreCompletions addObject:completion.copy];
    if (self.restoreCompletions.count == 1) { // restore 只执行一次，后面加进来的只记录completion
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
}

// MARK: - Priv

- (void)_restoreCompletion:(SKPaymentQueue *)queue error:(NSError *)error {
    [self.safe async:^{
        [self __restoreCompletion:queue error:error];
    }];
}

- (void)__restoreCompletion:(SKPaymentQueue *)queue error:(NSError *)error {
    NSMutableSet *set = [NSMutableSet set];
    for (SKPaymentTransaction *transaction in queue.transactions) {
        LZInPurchaseProductIden iden = transaction.originalTransaction.payment.productIdentifier;
        if (iden) {
            [set addObject:iden];
        }
        [self _transactionDone:transaction];
    }
    
    // save local file
    if (!error) {
        [self _saveVIPStatusWithIdens:set];
    }
        
    // callback
    for (LZInPurchaseRestoreCompletion completion in self.restoreCompletions) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(set, error);
        });
    }
    [self.restoreCompletions removeAllObjects];
}

- (void)_payCompletion:(SKPaymentTransaction *)transaction {
    [self.safe async:^{
        [self __payCompletion:transaction];
    }];
}

- (void)__payCompletion:(SKPaymentTransaction *)transaction {
    [self _transactionDone:transaction];
    
    if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
        [self _saveVIPStatusWithIdens:[NSSet setWithObjects:transaction.payment.productIdentifier, nil]];
    }
    LZLoggerInfo(@"transaction state: %d", (int)transaction.transactionState);
    LZInPurchaseTaskWrapper *wrapper = self.payMap[transaction.payment.lz_uuid];
    if (wrapper.completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ((LZInPurchasePayCompletion)wrapper.completion)(transaction.payment.productIdentifier, transaction.error);
        });
        self.payMap[transaction.payment.lz_uuid] = nil;
        
        // 检测票据
        [self _checkReceipt:YES completion:nil];
    }
}

// 表示已经消费完成
- (void)_transactionDone:(SKPaymentTransaction *)transaction {
    switch (transaction.transactionState) {
        case SKPaymentTransactionStatePurchased:
        case SKPaymentTransactionStateRestored:
        case SKPaymentTransactionStateFailed:
        {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
            break;
        default: break;
    }
}

// MARK: - SKPaymentTransactionObserver

// MARK: - Restore
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    [self _restoreCompletion:queue error:error];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    [self _restoreCompletion:queue error:nil];
}

// MARK: - Pay Product
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            LZLoggerInfo(@"正在购买: %ld", (long)SKPaymentTransactionStatePurchasing);
            continue;
        }
        
        [self _payCompletion:transaction];
    }
}

- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product { // MARK: ???
    return YES;
}

@end

@implementation LZInPurchaseManager (CheckReceipt)

- (void)_checkReceipt:(BOOL)online completion:(LZInPurchaseCheckReceiptCompletion)completion {
    // 交易验证
    NSURL *recepitUrl = [[NSBundle mainBundle] appStoreReceiptURL];
#if 0
    NSError *receiptError = nil;
    BOOL isPresent = [recepitUrl checkResourceIsReachableAndReturnError:&receiptError];
    if (!isPresent) {
        // 验证失败
    }
#endif
    NSData *receipt = [NSData dataWithContentsOfURL:recepitUrl];
    if (!receipt) {
        // 交易凭证为空验证失败
        if (completion) completion(nil, LZErrorResult2(LZErrorDomainFromInstance, 0));
        return;
    }
    
    NSError *error = nil;
    NSDictionary *requestContents = @{
        @"receipt-data": [receipt base64EncodedStringWithOptions:0],
        @"password" : self.password
    };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    if (!requestData) { // 交易凭证为空验证失败
        if (completion) completion(nil, LZErrorResult2(LZErrorDomainFromInstance, 0));
        return;
    }

    NSString *serverString = online ? LZInPurchaseReceiptServerStringOnline : LZInPurchaseReceiptServerStringTest;
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !data) {
            if (completion) completion(nil, LZErrorResult2(LZErrorDomainFromInstance, 0));
            return;
        }
        
        if (self.noNeedUpdateReceiptInfos) {
            return;
        }
    
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error || !responseDict) {
            if (completion) completion(nil, LZErrorResult2(LZErrorDomainFromInstance, 0));
            return;
        }
        
        LZInPurchaseReceiptResponse *lzResponse = [self _parseReceiptResonse:responseDict];
        if (lzResponse.receipt || lzResponse.latest_receipt_info) {
            { // update vip state
                NSMutableSet *vipIdens = [NSMutableSet set];
                for (LZInPurchaseReceiptProduct1 *product in lzResponse.receipt.in_app) {
                    if ([product.expires_date_ms longLongValue] >= [product.purchase_date_ms longLongValue]) {
                        [vipIdens addObject:product.product_id];
                    }
                }
                for (LZInPurchaseReceiptProduct2 *product in lzResponse.latest_receipt_info) {
                    if ([product.expires_date_ms longLongValue] >= [product.purchase_date_ms longLongValue]) {
                        [vipIdens addObject:product.product_id];
                    }
                }
                [self _saveVIPStatusWithIdens:vipIdens];
            }
            { // update receipt infos
                self.noNeedUpdateReceiptInfos = YES;
                self.recepitInfos = lzResponse;
            }
        }
        if (completion) completion(lzResponse, nil);
    }];
    [task resume];
}

// MARK: - Priv

- (LZInPurchaseReceiptResponse *)_parseReceiptResonse:(NSDictionary *)dict {
    LZInPurchaseReceiptResponse *ret = [LZInPurchaseReceiptResponse yy_modelWithJSON:dict];
    return ret;
}

@end


@implementation LZInPurchaseManager (VIP)

- (NSSet<LZInPurchaseProductIden> *)vipIdens {
    return [NSSet setWithObjects:LZInPurchaseProductIdenWeekFreeTrial3,
                                 LZInPurchaseProductIdenWeek,
                                 LZInPurchaseProductIdenPermanent, nil];
}

- (BOOL)isVIP {
    return [LZUserDefault getBoolWithKey:LZInPurchasePersistenceKeyVIP];
}

- (void)_saveVIPStatusWithIdens:(NSSet <LZInPurchaseProductIden>*)idens {
    [LZUserDefault saveBool:[[self vipIdens] intersectsSet:idens] forKey:LZInPurchasePersistenceKeyVIP];
}

@end
