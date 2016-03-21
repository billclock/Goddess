//
//  TopTabBarView.m
//  Goddess
//
//  Created by wangyan on 2016－03－18.
//  Copyright © 2016年 Goddess. All rights reserved.
//
#define ITEMW 80
#define ITEMH 28

#define TAGBASE 1000
#define TAGSlide 600

#import "TopTabBarView.h"
@interface ttb_Button : UIButton
@end
@interface TopTabBarView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) NSArray * strArray;

@end
@implementation TopTabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        
        UIView * slider = [[UIView alloc]init];
        slider.tag = TAGSlide;
        slider.backgroundColor = [UIColor lightGrayColor];
        [self.scrollView addSubview:slider];
    }
    return self;
}
- (instancetype)initWithItems:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray * mArr = [NSMutableArray array];
    [mArr addObject:firstObj];
    
    va_list argumentList;
    va_start(argumentList, firstObj);
    id object;
    while(1){
        object = va_arg(argumentList,id);
        if (object == nil)
            break;
        [mArr addObject:object];
    }
    va_end(argumentList);
    
    
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.strArray = [NSArray arrayWithArray:mArr];
        [self additemView];
        [self itemDidSelect:0 animated:NO];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    for (int i = 0;i < self.strArray.count;i++){
        UIButton * button = [self viewWithTag:i+TAGBASE];
        button.frame = CGRectMake(i * ITEMW+1, 0, ITEMW-1, ITEMH);
    }
    self.scrollView.contentSize = CGSizeMake(self.strArray.count * ITEMW, 0);
}
- (void)additemView
{
    for (int i = 0;i < self.strArray.count;i++){
        UIButton * button = [[UIButton alloc] init];
        button.tag = i + TAGBASE;
        [button setTitle:self.strArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.scrollView insertSubview:button belowSubview:[self viewWithTag:TAGSlide]];
    }
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
//        [_scrollView setDelegate:self];
//        [_scrollView setBounces:NO];
        [_scrollView setAlwaysBounceHorizontal:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
//        [_scrollView setScrollEnabled:YES];
//        [_scrollView setPagingEnabled:YES];
    }
    return _scrollView;
}

- (void)itemButtonDidClick:(UIButton *)button
{
    NSInteger index = button.tag - TAGBASE;
    
    if (self.selected == index) {
        if ([self.delegate respondsToSelector:@selector(tabBarDidClickDuplicate:index:)]) {
            [self.delegate tabBarDidClickDuplicate:self index:index];
        }
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(tabBarDidSelect:index:)]) {
        [self.delegate tabBarDidSelect:self index:index];
    }
    
    self.selected = index;
    [self slideIfNeed];
    [self itemDidSelect:index animated:YES];
}
- (void)slideIfNeed
{
    ttb_Button * buttonItem = [self viewWithTag:self.selected + TAGBASE];
    CGRect rect = [self.scrollView convertRect:buttonItem.frame toView:self];
    //NSLog(@"%@",NSStringFromCGRect(rect));
    if (rect.origin.x + rect.size.width > self.frame.size.width - (self.strArray.count-1 >self.selected?ITEMW*0.5:0)) {
        CGFloat offset = (rect.origin.x + rect.size.width) - self.frame.size.width;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + offset + (self.strArray.count-1 >self.selected?ITEMW*0.5:0), 0) animated:YES];
    }
    if (rect.origin.x  < (self.selected?ITEMW*0.5:0)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + rect.origin.x - (self.selected?ITEMW*0.5:0), 0) animated:YES];
    }
}
- (void)itemDidSelect:(NSInteger)index animated:(BOOL)animated
{
    UIView * slider = [self viewWithTag:600];
    
    [UIView animateWithDuration:(animated?0.2:0.0) animations:^{
        slider.frame = CGRectMake(index * ITEMW, ITEMH, ITEMW, 10);
    }];
}
@end

@implementation ttb_Button


@end