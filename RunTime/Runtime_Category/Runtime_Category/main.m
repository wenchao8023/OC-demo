//
//  main.m
//  Runtime_Category
//
//  Created by chao on 2017/8/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyClass.h"
#import "MyClass+Category1.h"
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        /***
         *  方法load的顺序
         *  在main方法之前
         *  同一级别的按照 compile sources 中的顺序
         *  类本身会在类别之前 load
         */
        
        Class currentClass = [MyClass class];
        MyClass *my = [[MyClass alloc] init];
        
        NSLog(@"----------------判断是执行的哪个方法------------------");
        [my printName];
        
        /***
         *  此处执行的是类别中实现的方法
         *
         *  category的方法没有“完全替换掉”原来类已经有的方法，也就是说如果category和原来类都有methodA，那么category附加完成之后，类的方法列表里会有两个methodA
         *  category的方法被放到了新方法列表的前面，而原来类的方法被放到了新方法列表的后面，这也就是我们平常所说的category的方法会“覆盖”掉原来类的同名方法
         *  这是因为运行时在查找方法的时候是顺着方法列表的顺序查找的，它只要一找到对应名字的方法，就会罢休^_^，殊不知后面可能还有一样名字的方法。
         *
         *  表面上是类别中的方法覆盖了类本身的方法
         *  实际上是在方法列表中两个同名的方法都存在，只不过类别中的方法在类本身的方法的前面，程序只要找到一个对应名字的方法，就不会再去寻找后面的方法
         * 
         *  从前面的输出信息可以看出来，程序先 load 类本身，然后才会 load 类别，所以就会导致类别中的方法会在类本身的方法前面
         */
        
        
        NSLog(@"++++++++++++++++用类本身的方法覆盖类别中的方法+++++++++++++++++++");
        if (currentClass)
        {
            unsigned int methodCount;
            // 获取类的方法列表

            //  第一个参数：类，表明是哪个类([NSObject class])
            //  第二个参数：方法数，为输出，可以获取类的方法数量
            //  返回：类的方法数组指针
            
            //  通过返回的指针和count可以获取到所有方法
            Method *methodList = class_copyMethodList(currentClass, &methodCount);
            IMP lastImp = NULL;
            SEL lastSel = NULL;
            for (NSInteger i = 0; i < methodCount; i++)
            {
                //获取 oc 方法
                Method method = methodList[i];
                //获取方法名
                NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method))
                                                          encoding:NSUTF8StringEncoding];
                NSLog(@"%ld --> %@", i, methodName);
                
                //遍历获取同一个方法处在方法列表最下层的，也就是表示类本身的那个方法，抛弃类别中同名的方法，实现覆盖效果
                if ([@"printName" isEqualToString:methodName])
                {
                    lastImp = method_getImplementation(method);
                    lastSel = method_getName(method);
                }
            }
            
            //执行上面找到的那个方法
            typedef void (*fn)(id,SEL);
            
            if (lastImp != NULL)
            {
                fn f = (fn)lastImp;
                f(my,lastSel);
            }
            free(methodList);
        }
        
        // 直接给 name 赋值， crash '-[MyClass setName:]: unrecognized selector sent to instance 0x100300760'
//        my.name = @"hah";
        
        my.associatedName = @"关联属性";
        NSLog(@"associatedName : %@", my.associatedName);
    }
    
    return 0;
}
