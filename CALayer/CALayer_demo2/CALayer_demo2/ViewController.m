//
//  ViewController.m
//  CALayer_demo2
//
//  Created by chao on 2017/6/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"Snowman.jpeg"];
    
    // add it directly to our view's layer
    self.layerView.layer.contents = (__bridge id)image.CGImage;
    
    self.layerView.layer.contentsGravity = kCAGravityResizeAspect;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
