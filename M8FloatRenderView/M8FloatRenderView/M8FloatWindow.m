//
//  M8FloatWindow.m
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8FloatWindow.h"
#import "M8FloatWindowSingleton.h"

@implementation M8FloatWindow

+ (void)M8_addWindowOnTarget:(id)target onClick:(void (^)())callback {
    [[M8FloatWindowSingleton Instance] M8_addWindowOnTarget:target onClick:callback];
}

+ (void)M8_setWindowSize:(float)size {
    [[M8FloatWindowSingleton Instance] M8_setWindowSize:size];
}

+ (void)M8_setHideWindow:(BOOL)hide {
    [[M8FloatWindowSingleton Instance] M8_setHideWindow:hide];
}

+ (void)M8_updateTarget:(id)target {
    [[M8FloatWindowSingleton Instance] M8_updateTarget:target];
}
//+ (void)M8_setBackgroundImage:(NSString *)imageName forState:(UIControlState)UIControlState {
//    [[XHFloatWindowSingleton Ins] M8_setBackgroundImage:imageName forState:UIControlState];
//}

@end
