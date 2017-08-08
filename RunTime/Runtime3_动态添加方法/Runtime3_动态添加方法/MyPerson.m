//
//  MyPerson.m
//  Runtime3_动态添加方法
//
//  Created by 郭文超 on 16/9/20.
//  Copyright © 2016年 wc. All rights reserved.
//

#import "MyPerson.h"
#import <objc/message.h>

@implementation MyPerson

//没有返回值，也没有参数
//我们在这里要把隐式参数写出来，但是不用我们赋值，因为是系统在调用，会自己赋值
//所以这个函数的类型就是：void(id,SEL)
void helloOC(id self, SEL _cmd){
    NSLog(@"helloOC");
}

void helloSwift(id self, SEL _cmd, NSNumber *distance){
    NSLog(@"helloSwift: %@", distance);
}


//了解一点，任何方法都有两个隐式参数 self 和 _cmd（任何方法中都能敲出self，就是因为这个，self是别人传进来的;_cmd表示当前方法的方法编号）

//这里主要看外面是动态加载的对象的方法还是类的方法，而不是看当前方法前面的加减号来决定的
//只要一个对象调用了一个为实现的方法就会调用这个方法进行处理
//我们一般就在这里处理，动态添加方法
+(BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"selector: %@", NSStringFromSelector(sel));
    
    if (sel == NSSelectorFromString(@"eat")) {
        
        //第一个参数：给哪个类添加方法
        //第二个参数：添加哪个方法
        //第三个参数：方法的实现，函数名(方法最终都是转换成函数的，所以这里写函数名)
        //第四个参数：方法的类型 这里要看苹果的官方文档的类型编码
        class_addMethod(self, sel, (IMP)helloOC, "v@:");  
        
        return YES;
    }
    
    if (sel == NSSelectorFromString(@"run:")) {
        class_addMethod(self, sel, (IMP)helloSwift, "v@:");
    }
    
    return [super resolveInstanceMethod:sel];
}
@end
