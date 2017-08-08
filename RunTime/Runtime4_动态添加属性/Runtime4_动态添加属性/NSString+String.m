//
//  NSString+String.m
//  Runtime4_动态添加属性
//
//  Created by chao on 2017/8/8.
//  Copyright © 2017年 wc. All rights reserved.
//

#import "NSString+String.h"
#import <objc/message.h>

/**
 *  动态添加属性的本质是 指向外部已经存在的一个属性 而不是去在对象中创建一个属性
 */

@implementation NSString (String)

//static NSString *_name;
//
////在分类里声明属性 需要自己写set方法和get方法
//
//- (void)setName:(NSString *)name
//{
//    _name = name;
//}
//
//- (NSString *)name
//{
//    return _name;
//}

//添加属性 应该是与对象有关
- (void)setCount:(NSString *)count
{
    //set方法里设置关联
    
    //Associated 关联 联系
    //跟某个对象产生关联,添加属性
    /**
     * id obj 给哪个对象添加属性(产生关联)
     * const void *key 属性名 (根据key获取关联的对象) void * 相当于 id 万能指针 传c或者oc的都可以
     * id value 要关联的值
     * objc_AssociationPolicy policy 策略 宏对应assign retain copy (因为weak没有用 外面赋值完马上就会被销毁 所以没有weak)
     */
    objc_setAssociatedObject(self, @"count", count, OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)count
{
    //get方法里获取关联
    return [NSString stringWithFormat:@"%ld", [objc_getAssociatedObject(self, @"count") length]];
}

@end
