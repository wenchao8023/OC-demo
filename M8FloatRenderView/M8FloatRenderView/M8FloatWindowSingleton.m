//
//  M8FloatWindowSingleton.m
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8FloatWindowSingleton.h"
#import "M8FloatWindowController.h"

@implementation M8FloatWindowSingleton

+ (instancetype)Instance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
        
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _targetsArray = [NSMutableArray arrayWithCapacity:0];
        _floatVC = [[M8FloatWindowController alloc] init];
    }
    return self;
}



- (void)M8_addWindowOnTarget:(UIViewController *)target onClick:(void (^)())callback {
    
    [target addChildViewController:_floatVC];
    [target.view addSubview:_floatVC.view];
    [_floatVC setRootView];
    _floatWindowCallBack = callback;
    
    [_floatVC hiddeRenderView];
}

- (void)M8_updateTarget:(UIViewController *)target {
    [_floatVC.view removeFromSuperview];
    [_floatVC removeFromParentViewController];
    
    [self M8_addWindowOnTarget:target onClick:nil];
}

- (void)M8_setWindowSize:(float)size {
    [_floatVC setWindowSize:CGSizeMake(size, size / 3 * 4)];
}

- (void)M8_setHideWindow:(BOOL)hide {
    [_floatVC setWindowHide:hide];
}

//- (void)M8_setBackgroundImage:(NSString *)imageName forState:(UIControlState)UIControlState {
//    [_floatVC resetBackgroundImage:imageName forState:UIControlState];
//}


@end
