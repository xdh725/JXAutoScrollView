//
//  JXSquareAutoScrollView.m
//
//
//  Created by 谢东华 on 2017/11/7.
//  Copyright © 2018年 谢东华. All rights reserved.
//

#import "JXSquareAutoScrollView.h"
#import "JXInfiniteScrollView.h"
#import "JXPageControl.h"
#import "JXSlideContentCollectionViewCell.h"
#import "UIImage+Utilities.h"
#import "UIColor+Utilities.h"

static NSString * const kSlideContentReuseCellIdentifier = @"kSlideContentReuseCellIdentifier";
static NSString * const kSlideContentCellIdentifierDefalut = @"kSlideContentCellIdentifierDefault";

@interface JXSquareAutoScrollView () <JXInfiniteScrollViewDelegate, JXInfiniteScrollViewDataSource>

@property (nonatomic, strong) JXInfiniteScrollView *infiniteScrollView;
@property (nonatomic, strong) UIImageView *placeholdIgv;

@property (nonatomic, copy) JXInfiniteScrollViewTapHandler tapBlock;

@property (nonatomic, strong) NSMutableArray *arrayImageUrlStr;

@end


@implementation JXSquareAutoScrollView

- (instancetype)initWithFrame:(CGRect)frame tapHandler:(JXInfiniteScrollViewTapHandler)tapHandler {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        _infiniteScrollView = [[JXInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _infiniteScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _infiniteScrollView.delegate = self;
        _infiniteScrollView.dataSource = self;
        [self addSubview:_infiniteScrollView];
        
        CGSize foregroundSize = CGSizeMake(12,6);
        CGSize backgroundSize = CGSizeMake(6,6);
        
        UIImage *foregroundImage = [UIImage imageWithColor:[UIColor colorFromHexRGB:@"1DCE6C"] size:foregroundSize cornerRadius:2]; //APP 主题色调 浅绿色
        UIImage *backgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.4] size:backgroundSize cornerRadius:2];
        
        JXPageControl *pageControl = [[JXPageControl alloc] initWithFrame:CGRectMake(width-10-20, height-20, 20, 20) foregroundImage:foregroundImage backgroundImage:backgroundImage];
        pageControl.padding = 4;
        [_infiniteScrollView setPageControl:pageControl];
//        [pageControl makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.infiniteScrollView).offset(-10);
//            make.centerX.equalTo(self.infiniteScrollView);
//        }];
        _tapBlock = tapHandler;
        
        //防止无数据时的空白
        _placeholdIgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _placeholdIgv.backgroundColor = [UIColor clearColor];
//        _placeholdIgv.image = nil;
        [self addSubview:_placeholdIgv];
    }
    return self;
}

#pragma mark - public method

- (void)configWithImageUrlstr:(NSArray *)arrayImageUrlstr {
    self.arrayImageUrlStr = [NSMutableArray arrayWithArray:arrayImageUrlstr];
    [self.infiniteScrollView reloadData];
    
    if (_placeholdIgv && _placeholdIgv.superview) {
        [_placeholdIgv removeFromSuperview];
    }
}

- (void)adjustScrollViewAnimationStuckState {
    [self.infiniteScrollView adjustAnimationStuckState];
}

- (void)setAutoScrollInterval:(NSTimeInterval)timeInterval {
    [self.infiniteScrollView setAutoScrollTimeInterval:timeInterval];
}

#pragma mark - infiniteScrollView Delegate DataSource

- (void)infiniteScrollView:(nonnull JXInfiniteScrollView *)infiniteScrollView didSelectCellAtIndex:(NSInteger)index {
    if (self.tapBlock) {
        self.tapBlock(index);
    }
}

- (void)infiniteScrollView:(nonnull JXInfiniteScrollView *)infiniteScrollView configureCell:(nonnull __kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (index < 0 || index >= _arrayImageUrlStr.count) {
        return;
    }
    JXSlideContentCollectionViewCell *contentCell = cell;
    [contentCell configCellWithImageUrlPath:_arrayImageUrlStr[index] title:nil];
}

- (nonnull NSString *)infiniteScrollView:(nonnull JXInfiniteScrollView *)infiniteScrollView reuseIdentifierForItemAtIndex:(NSInteger)index {
    return kSlideContentReuseCellIdentifier;
}

- (nonnull NSString *)infiniteScrollViewDefault:(nonnull JXInfiniteScrollView *)infiniteScrollView {
    return kSlideContentCellIdentifierDefalut;
}

- (NSInteger)numberOfPageInInfiniteScrollView:(nonnull JXInfiniteScrollView *)infiniteScrollView {
    return _arrayImageUrlStr.count;
}

- (nonnull NSDictionary<NSString *,Class> *)registerInfoForInfiniteScrollView:(nonnull JXInfiniteScrollView *)infiniteScrollView {
    return @{kSlideContentReuseCellIdentifier: [JXSlideContentCollectionViewCell class], kSlideContentCellIdentifierDefalut: [UICollectionViewCell class]};
}

@end
