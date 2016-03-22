//
//  PhotoViewCell.m
//  myHelper
//
//  Created by wangyan on 2016－03－15.
//  Copyright © 2016年 idea. All rights reserved.
//

#import "PhotoBrowerOriginCell.h"

@interface UIScrollView (Touch)
@end

@interface PhotoBrowerOriginCell()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIControl * control;
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
    self.scrollView.contentSize = self.bounds.size;
    self.imageView.frame = self.bounds;
    self.control.frame = self.bounds;
}
- (UIControl *)control
{
    if (!_control) {
        _control = [[UIControl alloc]init];
        [_control addTarget:self action:@selector(clickDid:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _control;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [_scrollView addSubview:self.control];
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
- (void)clickDid:(UIControl *)control
{
    if ([self.delegate respondsToSelector:@selector(imageDidClick:)]){
        [self.delegate imageDidClick:self];
    }
}
@end
