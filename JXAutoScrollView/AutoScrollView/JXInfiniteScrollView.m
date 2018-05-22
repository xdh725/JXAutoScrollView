//
//  JXInfiniteScrollView.m
//  
//
//  Created by 谢东华 on 2017/11/6.
//  Copyright © 2017年 HuaZhongShiXun. All rights reserved.
//

#import "JXInfiniteScrollView.h"
#import "JXPageControl.h"

static const NSInteger kBufferPageCount = 4;

@interface JXInfiniteScrollView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JXPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, strong) NSNumber *beginDragPoint;
@property (nonatomic, assign) BOOL firstReload;

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

@end

@implementation JXInfiniteScrollView

#pragma mark - initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        
        [self addSubview:_collectionView];
        
        _autoScroll = YES;
        _firstReload = YES;
        
        _autoScrollTimeInterval = 5;
    }
    return self;
}

#pragma mark - UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataSource) {
        NSInteger count = [_dataSource numberOfPageInInfiniteScrollView:self];
        if (count > 1) {
            return count + kBufferPageCount;
        } else if (count > 0) {
            return count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    NSInteger actualIndex = [self actualIndexWithInternalIndex:indexPath.item];
    if (!_dataSource || actualIndex < 0) { //异常情况 一般不会进来
        reuseIdentifier = [_dataSource infiniteScrollViewDefault:self];
        return [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    reuseIdentifier = [_dataSource infiniteScrollView:self reuseIdentifierForItemAtIndex:actualIndex];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [_dataSource infiniteScrollView:self configureCell:cell atIndex:actualIndex];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate) {
        NSInteger actualIndex = [self actualIndexWithInternalIndex:indexPath.item];
        if (actualIndex < 0) {
            return;
        }
        [_delegate infiniteScrollView:self didSelectCellAtIndex:actualIndex];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginDragPoint = @(scrollView.contentOffset.x);
    [self stopScroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = (NSInteger)scrollView.contentOffset.x / (NSInteger)CGRectGetWidth(scrollView.bounds);
    NSInteger count = [self collectionView:_collectionView numberOfItemsInSection:0];
    if (count < 1+kBufferPageCount) {
        return;
    }
    if (!_beginDragPoint) {
        return;
    }
    CGFloat scrollWidth = CGRectGetWidth(scrollView.bounds);
    CGFloat beginX = CGFLOAT_IS_DOUBLE ? _beginDragPoint.doubleValue : _beginDragPoint.floatValue;
    CGFloat currentX = scrollView.contentOffset.x;
    CGFloat targetX = 0;
    if (currentX < beginX && page < kBufferPageCount * 0.5) {
        targetX = currentX + scrollWidth * (count - kBufferPageCount);
        [scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
    } else if (currentX > beginX && page >= count - kBufferPageCount * 0.5) {
        targetX = currentX - scrollWidth * (count - kBufferPageCount);
        [scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self startScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePageControlCurrentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePageControlCurrentPage];
}

#pragma mark - Event Response
- (void)onTimerFireAutoScroll:(NSTimer *)timer
{
    NSInteger count = [_collectionView numberOfItemsInSection:0];
    if (count < 1+kBufferPageCount) {
        return;
    }
    CGFloat scrollWidth = CGRectGetWidth(_collectionView.bounds);
    self.beginDragPoint = nil;
    
    NSInteger currentPage;
    if ((NSInteger)scrollWidth == 0) {
        currentPage = 0;
    }else {
        currentPage = (NSInteger)_collectionView.contentOffset.x / (NSInteger)scrollWidth;
    }
    NSInteger nextPage = 0;
    if (currentPage > count - kBufferPageCount) {
        currentPage = 1;
        [_collectionView setContentOffset:CGPointMake(currentPage * scrollWidth, 0) animated:NO];
    }
    nextPage = currentPage + 1;
    [_collectionView setContentOffset:CGPointMake(nextPage * scrollWidth, 0) animated:YES];
}

#pragma mark - public method
- (void)reloadData
{
    if (!_dataSource) {
        return;
    }
    [_collectionView reloadData];
    
    //更新页码控件总页数
    [self updatePageControlTotalPage];
    
    //第一次加载且可滑动需要设置偏移码
    NSInteger count = [_collectionView numberOfItemsInSection:0];
    if (_firstReload && count>1+kBufferPageCount) {
        _firstReload = NO;
        //第一次加载需要增加偏页，为保证正确偏移，需要延迟调用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_collectionView setContentOffset:CGPointMake(kBufferPageCount * 0.5 * CGRectGetWidth(_collectionView.bounds), 0) animated:NO];
        });
    }
    if (_autoScroll) {
        [self startScroll];
    }
}

- (void)startScroll
{
    if (!_autoScroll) {
        return;
    }
    if (!_autoScrollTimer) {
        _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(onTimerFireAutoScroll:) userInfo:nil repeats:YES];
    }else {
        [_autoScrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.autoScrollTimeInterval]];
    }
}

- (void)stopScroll
{
    [_autoScrollTimer setFireDate:[NSDate distantFuture]];
}

- (void)adjustAnimationStuckState
{
    CGFloat scrollWidth = CGRectGetWidth(_collectionView.bounds);
    CGFloat page = _collectionView.contentOffset.x / scrollWidth;
    BOOL stuck = (page - floor(page)) != 0;
    if (stuck) {
        [self onTimerFireAutoScroll:nil];
    }
}

#pragma mark - private method
- (NSInteger)actualIndexWithInternalIndex:(NSInteger)index
{
    if (!_dataSource) {
        return -1;
    }
    NSInteger actualIndex = 0;
    NSInteger totalCount = [_dataSource numberOfPageInInfiniteScrollView:self];
    if (totalCount > 1) {
        if (index < kBufferPageCount * 0.5) {
            actualIndex = totalCount - kBufferPageCount * 0.5 + index;
        } else if (index > totalCount + kBufferPageCount * 0.5 - 1) {
            actualIndex = index - kBufferPageCount - totalCount + 2;
        } else {
            actualIndex = index - kBufferPageCount * 0.5;
        }
    } else if (totalCount > 0) {
        actualIndex = 0;
    } else {
        actualIndex = -1;
    }
    return actualIndex;
}

- (void)updatePageControlCurrentPage
{
    NSInteger page = (NSInteger)_collectionView.contentOffset.x / (NSInteger)CGRectGetWidth(_collectionView.bounds);
    NSInteger actualPage = [self actualIndexWithInternalIndex:page];
    if (actualPage < 0) {
        return;
    }
    [_pageControl setCurrentPage:actualPage];
}

- (void)updatePageControlTotalPage
{
    NSInteger reallyCount = [_dataSource numberOfPageInInfiniteScrollView:self];
    if (reallyCount < 0) {
        return;
    }
    if (reallyCount == 1) {
        [_pageControl setNumberOfPages:0];
    } else {
        [_pageControl setNumberOfPages:reallyCount];
    }
}

#pragma mark - life cicyle

#pragma mark - setter/getter
- (void)setDataSource:(id<JXInfiniteScrollViewDataSource>)dataSource
{
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    NSDictionary<NSString *, Class> *registerInfo = [_dataSource registerInfoForInfiniteScrollView:self];
    [registerInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull reuseIdentifier, Class  _Nonnull cellClass, BOOL * _Nonnull stop) {
        [_collectionView registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
    }];
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    if (_autoScroll == autoScroll) {
        return;
    }
    _autoScroll = autoScroll;
    if (_autoScroll) {
        [self startScroll];
    }
}

- (void)setPageControl:(JXPageControl *)pageControl
{
    if (_pageControl == pageControl) {
        return;
    }
    
    [_pageControl removeFromSuperview];
    _pageControl = pageControl;
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-20, CGRectGetWidth(self.bounds), 20);
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_pageControl];
}

- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval {
    if (_autoScrollTimeInterval == autoScrollTimeInterval) {
        return;
    }
    _autoScrollTimeInterval = autoScrollTimeInterval;
}

@end
