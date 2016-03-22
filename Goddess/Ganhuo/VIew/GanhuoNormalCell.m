//
//  GanhuoNormalCell.m
//  Goddess
//
//  Created by wangyan on 2016－03－21.
//  Copyright © 2016年 Goddess. All rights reserved.
//

#import "GanhuoNormalCell.h"
@interface GanhuoNormalCell()
@property (weak, nonatomic) IBOutlet UIView *backView;


@end
@implementation GanhuoNormalCell

- (void)awakeFromNib {
 
    self.backView.layer.cornerRadius = 15.0;
    self.backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backView.layer.borderWidth = 1.0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
