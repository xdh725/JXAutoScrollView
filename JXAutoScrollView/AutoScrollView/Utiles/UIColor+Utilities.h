//
//  UIColor+Utilities.h
//  FriendCircle
//
//  Created by 谢东华 on 2017/11/13.
//  Copyright © 2017年 HuaZhongShiXun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utilities)

/**
 *  RGB值转换为UIColor对象
 *
 *  @param inColorString RGB值，如“＃808080”这里只需要传入“808080”
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString alpha:(CGFloat)alpha;

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString andOpacity:(float) alpha;

@end
