//
//  TopTabBarView.m
//  Goddess
//
//  Created by wangyan on 2016－03－18.
//  Copyright © 2016年 Goddess. All rights reserved.
//

#import "TopTabBarView.h"
@interface TopTabBarView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;

@end
@implementation TopTabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        self.backgroundColor = [UIColor yellowColor];
        
        for (int i = 0;i < 10;i++){
            UIButton * button = [[UIButton alloc] init];
            button.backgroundColor = [UIColor greenColor];
            [button setTitle:@"框架" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.scrollView addSubview:button];
        }
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    NSArray<UIButton *> * arr = self.scrollView.subviews;
    for (int i = 0;i < 10;i++){
        UIButton * button = arr[i];
        button.frame = CGRectMake(i * 80+1, 0, 79, 30);
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blueColor];

//        [_scrollView setDelegate:self];
//        [_scrollView setBounces:NO];
//        [_scrollView setAlwaysBounceHorizontal:NO];
//        [_scrollView setShowsVerticalScrollIndicator:NO];
//        [_scrollView setShowsHorizontalScrollIndicator:NO];
//        [_scrollView setScrollEnabled:YES];
//        [_scrollView setPagingEnabled:YES];
    }
    return _scrollView;
}


@end
