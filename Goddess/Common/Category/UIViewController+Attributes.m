//
//  UIViewController+Attributes.m
//  Goddess
//
//  Created by wangyan on 2016－03－22.
//  Copyright © 2016年 Goddess. All rights reserved.
//

#import "UIViewController+Attributes.h"



@implementation UIViewController(Attributes)

id attributes_key;
-(void)setAttributes:(NSDictionary *)attributes
{
    objc_setAssociatedObject(self, &attributes_key, attributes, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSDictionary *)attributes{
    return objc_getAssociatedObject(self, &attributes_key);
}

@end
