//
//  UIColor+LZExtension.m
//  VideoDownloader
//
//  Created by 金胜利 on 2023/12/13.
//

#import "UIColor+LZExtension.h"

@implementation UIColor (LZExtension)

+ (UIColor *)colorWithHexString:(NSString *)color {
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if (cString.length != 6 && cString.length != 8)
    {
        return [UIColor clearColor];
    }
    NSRange range;
    range.length = 2;
    //b
    range.location = cString.length-2;
    NSString *bString = [cString substringWithRange:range];
    
    //g
    range.location = cString.length-4;
    NSString *gString = [cString substringWithRange:range];
    
    //r
    range.location = cString.length-6;
    NSString *rString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    if (cString.length==8) {
        range.location = cString.length-8;
        NSString *aString = [cString substringWithRange:range];
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
    }else{
        a=255.0;
    }
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:a/255.0];
}

@end
