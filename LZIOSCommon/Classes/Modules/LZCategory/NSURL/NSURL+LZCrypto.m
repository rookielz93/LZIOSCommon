//
//  NSURL+LZCrypto.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/9/18.
//

#import "NSURL+LZCrypto.h"
#import "NSString+LZCrypto.h"

@implementation NSURL (LZCrypto)

- (NSString *)toMD5 {
    return self.absoluteString.toMD5;
}

- (NSString *)uniqueFileName {
    return [NSString stringWithFormat:@"%@.%@", self.toMD5, self.pathExtension];
}

- (NSString *)uniqueFileNameFromBase {
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    components.query = nil;
    return [components.URL uniqueFileName];
}

@end
