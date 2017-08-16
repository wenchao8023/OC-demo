//
//  Person.m
//  NSThread-demo
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "Person.h"


@implementation Person

+ (instancetype)personWithName:(NSString *)name
{
    Person *person = [[Person alloc] init];
    person.name = name;
    return person;
}

- (void)personDemo:(id)obj
{
    NSLog(@"创建的人名 => %@",self.name);
    NSLog(@"hello %@",[NSThread currentThread]);
}

@end
