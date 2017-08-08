//
//  main.m
//  Runtime2_方法交换
//
//  Created by 郭文超 on 16/9/20.
//  Copyright © 2016年 wc. All rights reserved.
//


//交换方法可以    把系统自带的方法换成我们的方法。

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "MyPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!\n");
        
        Method methoud1 = class_getInstanceMethod([MyPerson class], @selector(run));
//        class_getClassMethod(<#__unsafe_unretained Class cls#>, <#SEL name#>)这个是用来得到类方法的，上面的是用来得到对象方法的。
        Method methoud2 = class_getInstanceMethod([MyPerson class], @selector(study));
        
        //交换两个方法
        method_exchangeImplementations(methoud1, methoud2);
        
        
        //利用runtime的这个技术可以让p调用run的时候执行study方法，调用study的时候执行run方法。
        MyPerson *p = [MyPerson new];
        
        [p run];
        [p study];

        NSLog(@"\n");
        
        
        //交换两个私有方法
        Method newMethod1 = class_getInstanceMethod([MyPerson class], @selector(newRun));
        Method newMethod2 = class_getInstanceMethod([MyPerson class], @selector(newStudy));
        method_exchangeImplementations(newMethod1, newMethod2);
        
        MyPerson *p1 = objc_msgSend([MyPerson class], @selector(new));
        objc_msgSend(p1, @selector(newRun));
        objc_msgSend(p1, @selector(newStudy));
    }
    return 0;
}
