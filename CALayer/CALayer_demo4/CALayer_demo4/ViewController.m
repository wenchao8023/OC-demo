//
//  ViewController.m
//  CALayer_demo4
//
//  Created by chao on 2017/6/2.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CALayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *layerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // create Layer
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.f, 50.f, 100.f, 100.f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    // set controller as layer delegate
    blueLayer.delegate = self;
    
    // ensure that layer backing image uses correct scale
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    
    // add layer to our view
    [self.layerView.layer addSublayer:blueLayer];
    
    // force layer to redraw
    [blueLayer display];
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    // draw a thick red circle
    CGContextSetLineWidth(ctx, 10.f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
