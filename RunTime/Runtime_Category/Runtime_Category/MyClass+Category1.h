//
//  MyClass+Category1.h
//  Runtime_Category
//
//  Created by chao on 2017/8/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MyClass.h"

@interface MyClass (Category1)

@property (nonatomic, copy) NSString *name;

//关联之后的属性, (使用runtime动态添加的属性)
@property (nonatomic, copy) NSString *associatedName;

@end
