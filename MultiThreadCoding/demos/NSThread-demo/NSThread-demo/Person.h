//
//  Person.h
//  NSThread-demo
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

/// 人名
@property (nonatomic,copy) NSString *name;
/// 创建人得构造方法
+ (instancetype)personWithName:(NSString *)name;
/// 人有个方法
- (void)personDemo:(id)obj;

@end
