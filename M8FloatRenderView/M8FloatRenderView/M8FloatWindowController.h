//
//  M8FloatWindowController.h
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


@class M8FloatRenderView;
@interface M8FloatWindowController : UIViewController

- (void)setRootView;
- (void)setWindowHide:(BOOL)hide;
- (void)setWindowSize:(CGSize)size;

- (void)hiddeRenderView;

@end
