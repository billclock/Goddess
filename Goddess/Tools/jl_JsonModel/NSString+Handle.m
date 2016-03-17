//
//  NSString+Handle.m
//  myHelper
//
//  Created by gaodun on 16/2/26.
//  Copyright © 2016年 idea. All rights reserved.
//

#import "NSString+Handle.h"

@implementation NSString(Handle)
- (NSString *)myuppercaseString
{
    NSString * first = [self substringWithRange:NSMakeRange(0, 1)].uppercaseString;
    return [first stringByAppendingString:[self substringWithRange:NSMakeRange(1, self.length-1)]];
}
@end
