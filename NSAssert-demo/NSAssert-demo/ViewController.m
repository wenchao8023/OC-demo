//
//  ViewController.m
//  NSAssert-demo
//
//  Created by chao on 2017/5/20.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "ViewController.h"

#import "MyAssertHandler.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    int a = 1;
//    NSAssert(a == 2, @"a must equal to 2");
    
//    [self assertWithPara:@"succ"];
//    NSLog(@"succ");
//    [self assertWithPara:@""];
//    NSLog(@"null");
////    [self assertWithPara:nil];
//    NSLog(@"nil");
    
    
    MyAssertHandler *myHandler = [[MyAssertHandler alloc] init];
    
    
    
    [[[NSThread currentThread] threadDictionary] setValue:myHandler
                                                   forKey:NSAssertionHandlerKey];
    
    [myHandler handleFailureInMethod:@selector(assertWithPara:) object:@"succ" file:@"isFile" lineNumber:110 description:@"isDescription"];
    NSLog(@"succ");
    [myHandler handleFailureInMethod:@selector(assertWithPara:) object:@"" file:@"isFile" lineNumber:110 description:@"isDescription"];
    NSLog(@"null");
    [myHandler handleFailureInMethod:@selector(assertWithPara:) object:nil file:@"isFile" lineNumber:110 description:@"isDescription"];
    NSLog(@"nil");
}

- (void)assertWithPara:(NSString *)str {
    NSParameterAssert(str);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
