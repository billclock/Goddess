//
//  TopTabBarView.h
//  Goddess
//
//  Created by wangyan on 2016－03－18.
//  Copyright © 2016年 Goddess. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopTabBarViewDelegate;

@interface TopTabBarView : UIView
@property (nonatomic,assign) NSInteger selected;
@property (nonatomic,weak) id<TopTabBarViewDelegate> delegate;
- (instancetype)initWithItems:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
@end

@protocol TopTabBarViewDelegate <NSObject>
- (void)tabBarDidSelect:(TopTabBarView *)tabBarView index:(NSInteger)index;
- (void)tabBarDidClickDuplicate:(TopTabBarView *)tabBarView index:(NSInteger)index;
@end