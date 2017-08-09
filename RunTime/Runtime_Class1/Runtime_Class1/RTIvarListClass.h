//
//  RTIvarListClass.h
//  Runtime_Class1
//
//  Created by chao on 2017/8/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTIvarListClass : NSObject
{
    float _weight;
}

@property (nonatomic, assign) int age;

@property (nonatomic, assign) float height;

@property (nonatomic, copy, nullable) NSString *name;

@property (nonatomic, copy, nullable) NSString *address;






- (void)testFunction;

- (void)testFunction1:(id _Nullable )obj;

- (void)testFunction2:(int)num;

- (void)testFunction3:(float)f;

@end
