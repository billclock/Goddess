//
//  NSObject+JsonModel.h
//  myHelper
//
//  Created by gaodun on 16/2/26.
//  Copyright © 2016年 idea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(jl_JsonModel)
+ (instancetype)jl_modelWithDictionary:(NSDictionary *)data;
+ (NSArray *)jl_modelsWithDictionaryArray:(NSArray *)array;
@end
