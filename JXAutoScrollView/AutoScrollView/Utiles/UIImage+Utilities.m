//
//  UIImage+Utilities.m
//  FriendCircle
//
//  Created by 谢东华 on 2017/11/13.
//  Copyright © 2017年 HuaZhongShiXun. All rights reserved.
//

#import "UIImage+Utilities.h"

@implementation UIImage (Utilities)

@end

@implementation UIImage (ColorWithRaduis)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    UIImage *image;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [path addClip];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
