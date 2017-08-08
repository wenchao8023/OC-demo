//
//  main.m
//  Runtime_1消息机制
//
//  Created by 郭文超 on 16/9/20.
//  Copyright © 2016年 wc. All rights reserved.
//

/****
     任何方法的本质就是发送消息，用runtime发送消息，oc底层通过runtime来实现
     
     验证：方法的调用，是否真的是转换为消息机制
     
     调用方法最终生成消息机制，是编译器帮我们做的事情
     最终代码需要把当前代码重新编译，用xcode的编译器，clang编译器
     clang -rewrite-objc main.m  其实OC最终会转换成C++代码
     
     
     使用runtime导入头文件objc/runtime.h 或者objc/message.h 后者也包含了前者
     runtime的任何函数都有一个前缀，谁的事谁使用
     补充一点类方法都是由类对象来调用的 [NSObject class]就是一个类对象
     
     
     需要使用runtime：
     1.装逼
     2.调用私有方法
*****/

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import "MyPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        //XCode6之前可以是使用objc_msgSend()这个方法其实是有参数的，
        
        //XCode6之后苹果不建议我们使用runtime
        //首先在build setting 搜索msg 改为NO
        
        
        //用消息机制 创建一个id对象
        id objc = objc_msgSend([NSObject class], @selector(alloc));
        objc = objc_msgSend(objc, @selector(init));
        
        
        //用消息机制 创建一个MyPerson对象
        MyPerson *p = objc_msgSend([MyPerson class], @selector(alloc));
        p = objc_msgSend(p, @selector(init));
        
        //利用消息机制调用方法
        /*
         首先要明白：
         对象方法：保存到类对象的方法列表中
         类方法： 保存到元类的方法列表中
         
         步骤：
         1.去寻找对应的类方法：每个对象都有一个isa指针，都是通过这个指针去对应的类中查找方法
         2.注册一个方法编号。
         3.根据方发编号查找对应的方法
         4.找到的只是最终函数实现的一个地址，再去方法区找类的实现（方法最终都是转换成函数保存的）
         */
        
        /*
         内存有5大区域：栈  堆  静态区  常量区  方法区域
         栈：不需要手动管理内存，自动管理
         堆：需要手动去管理内存的，自己释放
         */
        
        //用消息机制 调用公有方法
        objc_msgSend(p, @selector(eat));
        //用消息机制 调用私有方法
        objc_msgSend(p, @selector(running:), 100);
        //用消息机制 调用私有方法，私有方法可以访问私有属性
        objc_msgSend(p, @selector(running1));
        
        //用实例来调用对象方法
        [p eat];
        
        MyPerson *p1 = objc_msgSend([MyPerson class], @selector(new));
        objc_msgSend(p1, @selector(running1));
        NSInteger distance = objc_msgSend(p1, @selector(getDistance));
        NSLog(@"距离是%ld", distance);
        
    }
    return 0;
}
