//
//  ViewController.m
//  CALayer_demo5
//
//  Created by chao on 2017/6/2.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /** UIView 和 CALayer 布局区别 **
     *      UIView有三个比较重要的布局属性：frame，bounds和center
     *      CALayer对应地叫做frame，bounds和position
     *      --为了能清楚区分，图层用了“position”，视图用了“center”，但是他们都代表同样的值。
     */
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
    
    [self printDesc:view1];
    
    
//    [self setRotation:view1];
//    NSLog(@"-----------------旋转45°");
//    [self printDesc:view1];
    
    
    
    /** 锚点 **
     *  anchorPoint 和 position 共同确定 Layer 的中心点
     */
    [self setAnchorPoint:view1];
    NSLog(@"-----------------移动 anchorPoint");
    [self printDesc:view1];
}

- (void)setAnchorPoint:(UIView *)view1 {
    view1.layer.anchorPoint = CGPointMake(0, 0);
}

- (void)setRotation:(UIView *)view1 {
    [view1 setTransform:CGAffineTransformMakeRotation(M_PI_4)];
}

- (void)printDesc:(UIView *)view1 {
    
    NSLog(@"\nView:");
    printf("frame = "); [self printRect:view1.frame];
    printf("bounds = "); [self printRect:view1.bounds];
    printf("center = "); [self printPoint:view1.center];
    
    NSLog(@"");
    
    NSLog(@"\nLayer:");
    printf("frame = "); [self printRect:view1.layer.frame];
    printf("bounds = "); [self printRect:view1.layer.bounds];
    printf("position = "); [self printPoint:view1.layer.position];
    printf("anchorPoint = "); [self printPoint:view1.layer.anchorPoint];
}

- (void)printRect:(CGRect)rect {
    printf("{%g, %g, %g, %g}\n", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

- (void)printPoint:(CGPoint)point {
    printf("{%g, %g}\n", point.x, point.y);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
