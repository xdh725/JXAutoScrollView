//
//  JXInfiniteScrollView.h
//  
//
//  Created by 谢东华 on 2017/11/6.
//  Copyright © 2017年 HuaZhongShiXun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JXInfiniteScrollView;
@class JXPageControl;

@protocol JXInfiniteScrollViewDataSource <NSObject>

- (NSInteger)numberOfPageInInfiniteScrollView:(JXInfiniteScrollView *)infiniteScrollView;   //数据源的item数量
- (NSDictionary<NSString *, Class> *)registerInfoForInfiniteScrollView:(JXInfiniteScrollView *)infiniteScrollView;  //注册不同的cell
- (NSString *)infiniteScrollView:(JXInfiniteScrollView *)infiniteScrollView reuseIdentifierForItemAtIndex:(NSInteger)index; //不同item的reuseId
- (NSString *)infiniteScrollViewDefault:(JXInfiniteScrollView *)infiniteScrollView; //默认的reuseIdentifier
- (void)infiniteScrollView:(JXInfiniteScrollView *)infiniteScrollView configureCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index; //

@end


@protocol JXInfiniteScrollViewDelegate <NSObject>

- (void)infiniteScrollView:(JXInfiniteScrollView *)infiniteScrollView didSelectCellAtIndex:(NSInteger)index;

@end


@interface JXInfiniteScrollView : UIView

@property (nonatomic, weak) id<JXInfiniteScrollViewDelegate> delegate;
@property (nonatomic, weak) id<JXInfiniteScrollViewDataSource> dataSource;
@property (nonatomic, assign) BOOL autoScroll;

- (void)reloadData;
- (void)startScroll;
- (void)stopScroll;
- (void)adjustAnimationStuckState;

- (void)setPageControl:(JXPageControl *)pageControl;
- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval;

@end

NS_ASSUME_NONNULL_END
