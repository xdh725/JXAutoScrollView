//
//  JXSquareAutoScrollView.h
//  
//
//  Created by 谢东华 on 2017/11/7.
//  Copyright © 2017年 HuaZhongShiXun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JXInfiniteScrollViewTapHandler)(NSInteger index);

@interface JXSquareAutoScrollView : UIView

- (instancetype)initWithFrame:(CGRect)frame tapHandler:(JXInfiniteScrollViewTapHandler)tapHandler;

- (void)configWithImageUrlstr:(NSArray *)arrayImageUrlstr;

// 从后台回到前台重置视图状态 避免异常情况
- (void)adjustScrollViewAnimationStuckState;

- (void)setAutoScrollInterval:(NSTimeInterval)timeInterval;

@end
