//
//  MyClass.m
//  Runtime_Category
//
//  Created by chao on 2017/8/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MyClass.h"

@implementation MyClass

+ (void)load
{
    NSLog(@"%s", __func__);
}

- (void)printName
{
    NSLog(@"%@", @"MyClass");
}
@end

@implementation MyClass(MyAddition)

- (void)printName
{
    NSLog(@"%@", @"MyAddition");
}

@end
