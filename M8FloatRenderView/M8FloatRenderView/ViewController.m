//
//  ViewController.m
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "ViewController.h"

#import "M8FloatWindow.h"

#import "ViewController1.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick {
    ViewController1 *vc1 = [[ViewController1 alloc] init];
    [self presentViewController:vc1 animated:YES completion:^{
        [M8FloatWindow M8_updateTarget:vc1];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    
//    // 1.add floating button
    [M8FloatWindow M8_addWindowOnTarget:self onClick:^{
        // do something after floating button clicked...
        NSLog(@"Floating button clicked!!!");
    }];
//
//    // 2.hide or not test
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [M8FloatWindow M8_setHideWindow:YES];
//    });
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [M8FloatWindow M8_setHideWindow:NO];
//    });
//    
//    // 3.resize the button after 2 secs
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [M8FloatWindow M8_setWindowSize:60];
//    });
    
    // 4.reset the background image for normal and selected state
    //[XHFloatWindow M8_setBackgroundImage:@"default_normal" forState:UIControlStateSelected];
    //[XHFloatWindow M8_setBackgroundImage:@"default_normal" forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"viewController release");
}

@end
