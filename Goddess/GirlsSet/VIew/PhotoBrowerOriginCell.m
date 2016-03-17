//
//  PhotoViewCell.m
//  myHelper
//
//  Created by wangyan on 2016－03－15.
//  Copyright © 2016年 idea. All rights reserved.
//

#import "PhotoBrowerOriginCell.h"
@interface PhotoBrowerOriginCell()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;
@end
@implementation PhotoBrowerOriginCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:self.scrollView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)reuse
{
    self.scrollView.zoomScale = 1.0;
}
- (void)layoutSubviews
{
    self.scrollView.frame = self.bounds;
    self.imageView.frame = self.bounds;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [_scrollView addSubview:self.imageView];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale=2.0;
        _scrollView.minimumZoomScale=1;
    }
    return _scrollView;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:500];
}
@end
