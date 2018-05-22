//
//  JXPageControl.h
//
//
//  Created by 谢东华 on 2017/11/7.
//  Copyright © 2017年 HuaZhongShiXun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXPageControl : UIView

@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) BOOL hideForSignalPage;

- (instancetype)initWithFrame:(CGRect)frame
              foregroundImage:(UIImage *)foregroundImage
              backgroundImage:(UIImage *)backgroundImage;

- (void)setNumberOfPages:(NSInteger)numberOfPages;
- (void)setCurrentPage:(NSInteger)currentPage;

@end
