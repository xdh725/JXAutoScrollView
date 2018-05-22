//
//  JXSlideContentCollectionViewCell.m
//
//
//  Created by 谢东华 on 2017/11/7.
//  Copyright © 2017年 HuaZhongShiXun. All rights reserved.
//

#import "JXSlideContentCollectionViewCell.h"
#import <YYWebImage.h>

@interface JXSlideContentCollectionViewCell ()

@property (nonatomic, strong) YYAnimatedImageView *contentImageView;

@end


@implementation JXSlideContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _contentImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_contentImageView];
    }
    return self;
}

- (void)configCellWithImageUrlPath:(NSString *)imageUrlPath title:(NSString *)title
{
    if (!imageUrlPath) {
        _contentImageView.image = nil;
        return;
    }
    [_contentImageView yy_setImageWithURL:[NSURL URLWithString:imageUrlPath] placeholder:nil];
}

@end
