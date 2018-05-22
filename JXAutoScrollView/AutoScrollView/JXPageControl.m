//
//  JXPageControl.m
//
//
//  Created by 谢东华 on 2017/11/7.
//  Copyright © 2018年 谢东华. All rights reserved.
//

#import "JXPageControl.h"

@interface JXPageControl ()

@property (nonatomic, strong) UIImage *foregroundImage;
@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) CGFloat verticalPadding;

@property (nonatomic, strong) NSMutableArray *contentLayers;

@end


@implementation JXPageControl

#pragma mark - initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    CGSize dotSize = CGSizeMake(5, 5);
    return [self initWithFrame:frame foregroundImage:[self imageWithColor:[UIColor whiteColor] withSize:dotSize] backgroundImage:[self imageWithColor:[UIColor colorWithWhite:1 alpha:0.3] withSize:dotSize]];
}

- (instancetype)initWithFrame:(CGRect)frame
              foregroundImage:(UIImage *)foregroundImage
              backgroundImage:(UIImage *)backgroundImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _foregroundImage = foregroundImage;
        _backgroundImage = backgroundImage;
        _numberOfPages = 0;
        _currentPage = 0;
        _contentLayers = [NSMutableArray arrayWithCapacity:6];
        _padding = 9;
        _verticalPadding = 8;
        _hideForSignalPage = YES;
    }
    return self;
}

#pragma mark - override method
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize foregroundSize = _foregroundImage.size;
    CGSize backgroundSize = _backgroundImage.size;
    CGFloat padding = _padding;
    CGFloat currentPage = _currentPage;
    CGFloat centerY = CGRectGetMidY(self.bounds);
    __block CGFloat currentLeft = (CGRectGetWidth(self.frame) - foregroundSize.width - (backgroundSize.width+padding)*(_numberOfPages-1)) * 0.5;
    [_contentLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = backgroundSize;
        if (idx == currentPage) {
            size = foregroundSize;
        }
        layer.frame = CGRectMake(currentLeft, centerY-size.height*0.5, size.width, size.height);
        currentLeft += size.width+padding;
    }];
}

#pragma mark - private method
- (CGSize)intrinsicContentSize
{
    CGSize size = CGSizeMake(_foregroundImage.size.width + (_numberOfPages-1)*(_backgroundImage.size.width+_padding),
                             MAX(_foregroundImage.size.height, _backgroundImage.size.height) + _verticalPadding*2);
    return size;
}

- (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size
{
    //纯色指示器用位图足够
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - setter/getter
- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    if (numberOfPages < 0) {
        return;
    }
    if (_numberOfPages == numberOfPages) {
        return;
    }
    
    NSInteger currentCount = _contentLayers.count;
    if (currentCount > numberOfPages) {
        for (NSInteger i = currentCount-1; i>=numberOfPages; i--) {
            CALayer *layer = [_contentLayers objectAtIndex:i];
            [layer removeFromSuperlayer];
            [_contentLayers removeObjectAtIndex:i];
        }
    }else if (currentCount < numberOfPages) {
        for (NSInteger i=currentCount; i<numberOfPages; i++) {
            CALayer *layer = [[CALayer alloc] init];
            [self.layer insertSublayer:layer atIndex:0];
            [_contentLayers addObject:layer];
        }
    }
    _numberOfPages = numberOfPages;
    if (_numberOfPages < 2) {   //只有一页不显示pagecontrol
        self.hidden = _hideForSignalPage;
        return;
    }
    self.hidden = NO;
    
    __weak UIImage *weakForegroundImage = _foregroundImage;
    __weak UIImage *weakBackgroundImage = _backgroundImage;
    
    [_contentLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            layer.contents = (__bridge id _Nullable)(weakForegroundImage.CGImage);
        }else {
            layer.contents = (__bridge id _Nullable)(weakBackgroundImage.CGImage);
        }
    }];
    _currentPage = 0;
    
    [self setNeedsLayout];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (_currentPage == currentPage) {
        return;
    }
    NSInteger contentCount = _contentLayers.count;
    
    if (currentPage >= _numberOfPages || currentPage >= contentCount) {
        return;
    }
    
    _currentPage = MAX(_currentPage, 0);
    _currentPage = MIN(_currentPage, contentCount-1);
    
    [_contentLayers exchangeObjectAtIndex:_currentPage withObjectAtIndex:currentPage];
    _currentPage = currentPage;
    
    [self setNeedsLayout];  //通知 view 刷新视图
}

@end
