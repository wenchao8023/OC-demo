//
//  MyClass+Category1.m
//  Runtime_Category
//
//  Created by chao on 2017/8/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MyClass+Category1.h"
#import <objc/runtime.h>

@implementation MyClass (Category1)
+ (void)load
{
    NSLog(@"%s", __func__);
}

//这里的字符串都是用 "" 表示的，不适用 @"" 表示
- (void)setAssociatedName:(NSString *)associatedName
{
    objc_setAssociatedObject(self,
                             "associatedName",
                             associatedName,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)associatedName
{
    return objc_getAssociatedObject(self, "associatedName");
}


@end
