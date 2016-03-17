//
//  XMGPhotoCell.m
//  02-自定义布局
//
//  Created by xiaomage on 15/8/6.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "PhotoBrowerThumbCell.h"

@interface PhotoBrowerThumbCell()


@end

@implementation PhotoBrowerThumbCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode=UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)layoutSubviews
{
    self.imageView.frame = self.bounds;
}
@end
