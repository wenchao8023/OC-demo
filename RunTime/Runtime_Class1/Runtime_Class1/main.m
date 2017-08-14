//
//  main.m
//  Runtime_Class1
//
//  Created by chao on 2017/8/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>
#import "RTClass.h"
#import "RTClass1.h"
#import "SubRTClass.h"
#import "RTIvarListClass.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        
//        RTClass *testCls = [[RTClass alloc] init];
        

        NSLog(@"\n\n------1. 获取类名 class_getName");
        /** 1. 获取类名 class_getName
         * 函数原型
         *  OBJC_EXPORT const char *class_getName(Class cls)
         *  参数 ： class - 类
         *  返回 ： const char * - C 字符串
         */
        const char *clsName = class_getName([RTClass1 class]);
        NSString *className = [NSString stringWithUTF8String:clsName];
        NSLog(@"The class is : %@", className);
        
        
        NSLog(@"\n\n------2. 获取父类名 class_getSuperclass");
        /** 2. 获取父类名 class_getSuperclass
         * 函数原型
         *  OBJC_EXPORT Class class_getSuperclass(Class cls) 
         *  参数 ： class - 类
         *  返回 ： class - 类
         */
        Class superClass = class_getSuperclass([SubRTClass class]);
        NSLog(@"The super class is : %@", [NSString stringWithUTF8String:class_getName(superClass)]);
        
        
        NSLog(@"\n\n------");
        /** 3. class_setSuperclass 废弃
         * 函数原型
         *  OBJC_EXPORT Class class_setSuperclass(Class cls, Class newSuper)
         */

        
        NSLog(@"\n\n------");
        /** 4. 判断是否是元类 class_isMetaClass
         * 函数原型
         *  OBJC_EXPORT BOOL class_isMetaClass(Class cls)
         *  参数 ： class - 类
         *  返回 ： BOOL 是否是元类
         */
        //了解元类之后再做解释
        
        
        NSLog(@"\n\n------5. 获取类的字节大小 class_getInstanceSize");
        /** 5. 获取类的字节大小 class_getInstanceSize
         * 函数原型
         *  OBJC_EXPORT size_t class_getInstanceSize(Class cls)
         *  参数 ： class - 类
         *  返回 ： size_t 字节大小
         */
        size_t clsSize = class_getInstanceSize([RTClass class]);
        size_t clsSize1= class_getInstanceSize([RTClass1 class]);
        NSLog(@"\nThe class<%@> size is : %ld\nThe class<%@> size is : %ld",
              [NSString stringWithUTF8String:class_getName([RTClass class])], clsSize,
              [NSString stringWithUTF8String:class_getName([RTClass1 class])], clsSize1
              );
        
        
        NSLog(@"\n\n------");
        /** 6. 获取实例的属性 class_getInstanceVariable
         * 函数原型
         *  OBJC_EXPORT Ivar class_getInstanceVariable(Class cls, const char *name)
         *  参数1 ： class - 类
         *  参数2 ： 类的属性名（注意类型）
         *  返回  ： objc_ivar *Ivar 属性
         */
        
        
        NSLog(@"\n\n------");
        /** 7. 获取类的属性 class_getClassVariable
         * 函数原型
         *  OBJC_EXPORT Ivar class_getClassVariable(Class cls, const char *name)
         *  参数1 ： class - 类
         *  参数2 ： 类的属性名（注意类型）
         *  返回  ： objc_ivar *Ivar 属性
         */
        
        
        NSLog(@"\n\n------8. 获取成员变量数组 class_copyIvarList");
        /** 8. 获取成员变量数组 class_copyIvarList
         * 函数原型
         *  OBJC_EXPORT Ivar *class_copyIvarList(Class cls, unsigned int *outCount)
         *  参数1 ： class - 类
         *  参数2 ： 做返回值，成员变量个数
         *  返回  ： Ivar *数组
         *
         ** 8.1 获取成员变量名
         * 函数原型
         *  OBJC_EXPORT const char *ivar_getName(Ivar v)
         *  参数 ： Ivar 类型（上一个方法获取）
         *  返回 ： C 字符串
         */
        unsigned int ivarCount = 0;
        RTIvarListClass *ivarListInstance = [[RTIvarListClass alloc] init];
        Ivar *ivarList = class_copyIvarList([ivarListInstance class], &ivarCount);
        for (unsigned int i = 0; i < ivarCount; i++)
        {
            Ivar ivar = ivarList[i];
            const char *ivarName = ivar_getName(ivar);
            NSString *ivarStr = [NSString stringWithUTF8String:ivarName];
            NSLog(@"Ivar : %d -> %@", i, ivarStr);
        }
        
        
        NSLog(@"\n\n------9. 获取成员属性数组 class_copyPropertyList");
        /** 9. 获取成员属性数组 class_copyPropertyList
         * 函数原型
         *  OBJC_EXPORT objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount)
         *  参数1 ： class - 类
         *  参数2 ： 做返回值，成员属性个数
         *  返回  ： objc_property_t *数组
         *
         ** 9.1 获取成员属性名 property_getName
         * 函数原型
         *  OBJC_EXPORT const char *property_getName(objc_property_t property)
         *  参数 ： objc_property_t 类型（上一个方法获取）
         *  返回 ： C 字符串
         */
        unsigned int propertyCount = 0;
        objc_property_t *propertyList = class_copyPropertyList([RTIvarListClass class], &propertyCount);
        for (unsigned int i = 0; i < propertyCount; i++)
        {
            objc_property_t property = propertyList[i];
            const char *propertyName = property_getName(property);
            NSString *propertyStr = [NSString stringWithUTF8String:propertyName];
            NSLog(@"propertyStr : %d -> %@", i, propertyStr);
        }
        
        
        NSLog(@"\n\n------10. 获取方法数组 class_copyMethodList");
        /** 10. 获取方法数组 class_copyMethodList
         * 函数原型
         *  OBJC_EXPORT Method *class_copyMethodList(Class cls, unsigned int *outCount)
         *  参数1 ： class - 类
         *  参数2 ： 做返回值，方法个数
         *  返回  ： Method *数组
         *
         ** 10.1 获取方法名 method_getName
         * 函数原型
         *  OBJC_EXPORT SEL method_getName(Method m)
         *  参数 ： Method 类型（上一个方法获取）
         *  返回 ： SEL
         */
        unsigned int methodCount = 0;
        Method *methodList = class_copyMethodList([RTIvarListClass class], &methodCount);
        for (unsigned int i = 0; i < methodCount; i++)
        {
            Method method = methodList[i];
            SEL methodName = method_getName(method);
            NSString *methodStr = NSStringFromSelector(methodName);
            NSLog(@"methodStr : %d -> %@", i, methodStr);
        }
        
    }
    return 0;
}

