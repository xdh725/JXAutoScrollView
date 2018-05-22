//
//  UIImage+Utilities.h
//  FriendCircle
//
//  Created by 谢东华 on 2017/11/13.
//  Copyright © 2017年 HuaZhongShiXun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utilities)

@end

@interface UIImage (ColorWithRaduis)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

@end
