//
//  UIColor+Utilities.m
//  FriendCircle
//
//  Created by 谢东华 on 2017/11/13.
//  Copyright © 2017年 HuaZhongShiXun. All rights reserved.
//

#import "UIColor+Utilities.h"

@implementation UIColor (Utilities)

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    NSString *cString = [[inColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ( ([cString length] != 6) && ([cString length] != 8) ) return [UIColor blackColor];
    // Separate into a, r, g, b substrings
    NSRange range;
    NSUInteger location = 0, length = 2;
    range.location = location;
    range.length = length;
    
    BOOL isARGB = ([cString length] == 8); // 判断是否是带透明度的ARGB形式
    NSString *aString;
    if (isARGB) {
        aString = [cString substringWithRange:range];
        location += length;
        range.location = location;
    }
    
    NSString *rString = [cString substringWithRange:range];
    location += length;
    range.location = location;
    
    NSString *gString = [cString substringWithRange:range];
    location += length;
    range.location = location;
    
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int a, r, g, b;
    CGFloat alpha = 1.0;
    if (isARGB) {
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        alpha = a / 255.0f;
    }
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString alpha:(CGFloat)alpha
{
    if (alpha > 1.0) {
        alpha = 1.0;
    }
    if (alpha < 0.0) {
        alpha = 0.0;
    }
    
    NSString *cString = [[inColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString andOpacity:(float) alpha{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor colorWithRed: (float)redByte / 0xff green: (float)greenByte/ 0xff blue: (float)blueByte / 0xff alpha:alpha];
    return result;
}

@end
