//
//  LZPageModel.h
//  VideoDownloader
//
//  Created by lz on 2023/9/9.
//

#import <Foundation/Foundation.h>
#import "LZBaseModel.h"
#import "LZPageDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZPageModel : LZBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) LZPageIden iden;


@end

NS_ASSUME_NONNULL_END
