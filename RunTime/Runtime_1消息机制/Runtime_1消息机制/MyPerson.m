//
//  MyPerson.m
//  Runtime_1消息机制
//
//  Created by 郭文超 on 16/9/20.
//  Copyright © 2016年 wc. All rights reserved.
//

#import "MyPerson.h"

@interface MyPerson ()

@property (nonatomic, assign) NSInteger distance;

@end

@implementation MyPerson

-(instancetype)init{
    if (self == [super init]) {
        _distance = 150;
    }
    
    return self;
}

-(void)eat{
    NSLog(@"吃饭");
}

-(void)running:(NSInteger)meter{
    NSLog(@"跑了%ld米", meter);
}

-(void)running1{
    NSLog(@"跑了%ld米", _distance);
}

-(NSInteger)getDistance{
    return _distance;
}
@end
