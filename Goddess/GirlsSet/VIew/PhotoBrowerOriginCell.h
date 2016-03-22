//
//  PhotoViewCell.h
//  myHelper
//
//  Created by wangyan on 2016－03－15.
//  Copyright © 2016年 idea. All rights reserved.
//

#import "PhotoBrowerBaseCell.h"
@protocol PhotoBrowerOriginCellDelegate;

@interface PhotoBrowerOriginCell : PhotoBrowerBaseCell
- (void)reuse;
@property (nonatomic,weak) id<PhotoBrowerOriginCellDelegate> delegate;
@end

@protocol PhotoBrowerOriginCellDelegate <NSObject>

- (void)imageDidClick:(PhotoBrowerOriginCell *)cell;

@end
