//
//  NSObject+Property.m
//  Runtime4_动态添加属性
//
//  Created by 郭文超 on 16/9/20.
//  Copyright © 2016年 wc. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/message.h>

@implementation NSObject (Property)

-(void)setName:(NSString *)name{
    
    //    _name = name;
    
    //用这种全局的变量不好，要让字符串和当前类产生关系
    //Associated就是关联的意思
    //第一个参数：给那个对象添加属性
    //第二个参数：属性的名称
    //第三个参数： 属性的值
    //第四个参数：策略(枚举)
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)name{
    
//    return _name;
    return objc_getAssociatedObject(self, @"name");
}
@end
