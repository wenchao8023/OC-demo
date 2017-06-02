//
//  MyAssertHandler.m
//  NSAssert-demo
//
//  Created by chao on 2017/5/20.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MyAssertHandler.h"

@implementation MyAssertHandler
// 处理 oc 的断言
- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ... {
    NSLog(@"NSAssert Failure: Method %@ for object %@ in %@#%li", NSStringFromSelector(selector), object, fileName, (long)line);
}

// 处理 c 的断言
- (void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ... {
    NSLog(@"NSAssert Failure: Function (%@) in %@#%li", functionName, fileName, (long)line);
}

@end
