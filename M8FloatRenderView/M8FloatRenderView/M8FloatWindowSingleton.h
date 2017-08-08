//
//  M8FloatWindowSingleton.h
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CallBack)();

@class M8FloatWindowController;
@interface M8FloatWindowSingleton : NSObject

@property (nonatomic, strong, nullable) M8FloatWindowController *floatVC;
@property (nonatomic, copy, nullable) CallBack floatWindowCallBack;

@property (nonatomic, strong, nullable) NSMutableArray *targetsArray;

@property (nonatomic, strong, nullable) UIViewController *desViewController;

- (void)M8_addWindowOnTarget: (nonnull id)target onClick:(nullable void(^)())callback;
- (void)M8_updateTarget:(nonnull id)target;
- (void)M8_setWindowSize:(float)size;
- (void)M8_setHideWindow:(BOOL)hide;

+ (nonnull instancetype)Instance;

@end
