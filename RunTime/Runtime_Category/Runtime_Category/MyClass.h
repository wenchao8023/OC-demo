//
//  MyClass.h
//  Runtime_Category
//
//  Created by chao on 2017/8/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject

- (void)printName;

@end


@interface MyClass (MyAddition)

- (void)printName;

@end
