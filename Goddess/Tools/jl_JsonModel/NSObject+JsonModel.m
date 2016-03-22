//
//  NSObject+JsonModel.m
//  myHelper
//
//  Created by gaodun on 16/2/26.
//  Copyright © 2016年 idea. All rights reserved.
//

#import "NSObject+JsonModel.h"
#import "NSString+Handle.h"
#import <objc/runtime.h>

@implementation NSObject(jl_JsonModel)

- (instancetype)initWithDictionary: (NSDictionary *) data{
    {
        self = [self init];
        if (self) {
            [self assginToPropertyWithDictionary:data];
        }
        return self;
    }
}
+ (instancetype)modelWithDictionary: (NSDictionary *) data{
    
    return [[self alloc] initWithDictionary:data];
    
}
+ (instancetype)jl_modelWithDictionary: (NSDictionary *) data{
    
    return [self modelWithDictionary:data];
    
}
+ (NSArray *)jl_modelsWithDictionaryArray:(NSArray *)array;
{
    NSMutableArray * resultArray = [NSMutableArray array];
    NSEnumerator * enumerator = [array objectEnumerator];
    id object;
    while ((object = [enumerator nextObject])!= nil) {
        [resultArray addObject:[self modelWithDictionary:object]];
    }
    return [resultArray copy];
}
/************************************************************************
 *把字典赋值给当前实体类的属性
 *参数：字典
 *适用情况：当网络请求的数据的key与实体类的属性相同时可以通过此方法吧字典的Value
 *        赋值给实体类的属性
 ************************************************************************/

-(void) assginToPropertyWithDictionary: (NSDictionary *) data{
    
    if (data == nil) {
        return;
    }
    
    ///1.获取字典的key
    NSArray *dicKey = [data allKeys];
    
    ///2.循环遍历字典key, 并且动态生成实体类的setter方法，把字典的Value通过setter方法
    ///赋值给实体类的属性
    for (int i = 0; i < dicKey.count; i ++) {
        
        ///2.1 通过getSetterSelWithAttibuteName 方法来获取实体类的set方法
        SEL setSel = [self creatSetterWithPropertyName:dicKey[i]];
        
        if ([self respondsToSelector:setSel]) {
            ///2.2 获取字典中key对应的value
            NSString  *value = [NSString stringWithFormat:@"%@", data[dicKey[i]]];
            
            ///2.3 把值通过setter方法赋值给实体类的属性
            [self performSelectorOnMainThread:setSel
                                   withObject:value
                                waitUntilDone:[NSThread isMainThread]];
        }
        
    }
    
}
- (NSArray *) allPropertyNames{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}
- (SEL) creatGetterWithPropertyName: (NSString *) propertyName{
    
    //1.返回get方法: oc中的get方法就是属性的本身
    return NSSelectorFromString(propertyName);
}
- (void) displayCurrentModleProperty{
    
    //获取实体类的属性名
    NSArray *array = [self allPropertyNames];
    
    //拼接参数
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    for (int i = 0; i < array.count; i ++) {
        
        //获取get方法
        SEL getSel = [self creatGetterWithPropertyName:array[i]];
        
        if ([self respondsToSelector:getSel]) {
            
            //获得类和方法的签名
            NSMethodSignature *signature = [self methodSignatureForSelector:getSel];
            
            //从签名获得调用对象
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            
            //设置target
            [invocation setTarget:self];
            
            //设置selector
            [invocation setSelector:getSel];
            
            //接收返回的值
            NSObject *__unsafe_unretained returnValue = nil;
            
            //调用
            [invocation invoke];
            
            //接收返回值
            [invocation getReturnValue:&returnValue];
            
            [resultString appendFormat:@"%@\n", returnValue];
        }
    }
//    NSLog(@"%@", resultString);
    
}
- (SEL) creatSetterWithPropertyName: (NSString *) propertyName{
    
    //1.首字母大写
    propertyName = propertyName.myuppercaseString;
//    NSLog(@"%@",propertyName);
    //2.拼接上set关键字
    propertyName = [NSString stringWithFormat:@"set%@:", propertyName];
    
    //3.返回set方法
    return NSSelectorFromString(propertyName);
}


@end
