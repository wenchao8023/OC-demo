//
//  main.m
//  Runtime4_动态添加属性
//
//  Created by 郭文超 on 16/9/20.
//  Copyright © 2016年 wc. All rights reserved.
//

/*
 什么时候需要动态添加属性：给系统的类添加属性的时候可以使用runtime来操作
 本质：让某个属性与对象产生关联
 需求：让NSObject这个类保存一个字符串
 */

#import <Foundation/Foundation.h>
#import "MyPerson.h"
#import "NSObject+Property.h"
#import "NSString+String.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!\n");
        
        NSObject *obj = [NSObject new];
        obj.name = @"123";
        
        MyPerson *p = [MyPerson new];
        
        NSLog(@"person->name is %@", p.name);
        NSLog(@"obj->name is %@",obj.name);
        
        
        NSString *str = [NSString new];
        str.name = @"strName";
        str.count = @"222";
        NSLog(@"str->name is %@", str.name);
        NSLog(@"str->count is %@", str.count);
    }
    return 0;
}
