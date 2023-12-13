//
//  NSDictionary+LZExtension.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/12/13.
//

#import "NSDictionary+LZExtension.h"

@implementation NSDictionary (LZExtension)

- (NSString *)toJsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
