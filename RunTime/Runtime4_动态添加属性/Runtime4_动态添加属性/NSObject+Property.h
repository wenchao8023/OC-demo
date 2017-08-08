//
//  NSObject+Property.h
//  Runtime4_动态添加属性
//
//  Created by 郭文超 on 16/9/20.
//  Copyright © 2016年 wc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

//@property在分类中只会生成get 和set 方法的声明 ，不会实现，也不会说生成带下划线的成员变量
//@property(nonatomic,copy)NSString * name;

//没有属性（_name）所以在这里我们连策略也不需要，可以写成：
@property NSString *name;

@end
