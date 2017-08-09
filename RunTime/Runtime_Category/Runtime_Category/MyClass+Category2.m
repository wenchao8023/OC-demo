//
//  MyClass+Category2.m
//  Runtime_Category
//
//  Created by chao on 2017/8/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MyClass+Category2.h"

@implementation MyClass (Category2)
+ (void)load
{
    NSLog(@"%s", __func__);
}
@end
