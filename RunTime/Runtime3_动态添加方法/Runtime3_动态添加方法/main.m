//
//  main.m
//  Runtime3_动态添加方法
//
//  Created by 郭文超 on 16/9/20.
//  Copyright © 2016年 wc. All rights reserved.
//


/*
 什么时候需要动态添加方法：
 
 美团面试题：
 什么时候使用performSelector这个方法？：动态添加方法的时候使用过
 怎么动态添加方法？：runtime
 为什么要动态添加方法？：OC都是懒加载机制，只要一个方法实现了，就会马上添加到方法列表中（就会消耗内存）比如有些应用都有会员机制，一些特定的功能只能会员才能使用，所以这些功能就可以动态的去添加
 */

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import "MyPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!\n\n");
        
        MyPerson *p = [[MyPerson alloc] init];
        
        [p performSelector:@selector(eat)];
        [p performSelector:@selector(run:) withObject:@100];
        
    }
    return 0;
}
