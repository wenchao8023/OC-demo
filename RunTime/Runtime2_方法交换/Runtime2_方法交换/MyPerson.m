//
//  MyPerson.m
//  Runtime2_方法交换
//
//  Created by 郭文超 on 16/9/20.
//  Copyright © 2016年 wc. All rights reserved.
//

#import "MyPerson.h"

@implementation MyPerson

-(void)run{
    NSLog(@"run:%s", __func__);
}

-(void)study{
    NSLog(@"study:%s", __func__);
}

-(void)newRun{
    NSLog(@"run1:%s", __func__);
}

-(void)newStudy{
    NSLog(@"study1:%s", __func__);
}

@end
