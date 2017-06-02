//
//  ViewController.m
//  CALayerDemo
//
//  Created by chao on 2017/1/5.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>


#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /***    CALayer ***
     *  其实就是和 UIView 差不多的存在，这个是最基本的图层，还有子类
     *  CAGradientLayer
     *  CATiledLayer 
     *  CAShapeLayer
     *  CATextLayer
     *  CAEmitterLayer
     *  CAReplicatorLayer
     *  CAScrollLayer
     *  说到底就是和 UIView 一样的用法，可以创建很多个 子layer 添加在layer上，然后注意它们的添加顺序，这就是最基本的用法
     *
     *  在使用的时候很多时候都要和 UIBezierPath 贝尔赛曲线一起使用
     *  如果要用到动画的话需要使用 CABasicAnimation 动画来设置
     *
     *
     *
     ***    layer 的基本属性
     *  设置 layer 的大小，
     *  一般将 bounds.origin 给 {0, 0} 就好了
     *  bounds.size 用来确定图层的大小
     @property CGRect bounds;
     
     *  设置 layer 的中心位置， 但是需要与 anchorPoint 一起使用确定位置
     @property CGPoint position;
     
     *  配合 position 来确定图层的中心点
     *  默认是 {0.5, 0.5} x, y 的范围都是 [0, 1]
     *  这个值对应的是 宽高的位移比例 + position => 实际的中心点
     *  例如：size = {100, 150}, position = {200, 300}, anchorPoint = {0.8, 0.2}
     *  实际中心位置
     *      x = (0.5 - 0.8) * 100 + 200 ==> 170
     *      y = (0.5 - 0.2) * 150 + 300 ==> 345
     @property CGPoint anchorPoint;
     
     *  layer 的 frame
     @property CGRect frame;
     
     *  可以隐藏
     @property(getter=isHidden) BOOL hidden;
     
     *  父图层
     @property(nullable, readonly) CALayer *superlayer;
     
     - (void)removeFromSuperlayer;
     
     *  获取 layer 的所有子图层
     @property(nullable, copy) NSArray<CALayer *> *sublayers;
     
     * 下面三个属性是控制 z 轴的，也就是 3D 中的
     @property CGFloat zPosition;
     
     @property CGFloat anchorPointZ;
     
     @property CATransform3D transform;
     
     - (CGAffineTransform)affineTransform;
     - (void)setAffineTransform:(CGAffineTransform)m;
     
     *  --不知道
     @property(getter=isDoubleSided) BOOL doubleSided;
     
     *  --不知道
     @property(getter=isGeometryFlipped) BOOL geometryFlipped;
     
     - (BOOL)contentsAreFlipped;
     ***/
    
    /*** layer 图层基本方法
     *  方法的用法和 UIView 的基本方法用法一样
     - (void)addSublayer:(CALayer *)layer;

     - (void)insertSublayer:(CALayer *)layer atIndex:(unsigned)idx;

     - (void)insertSublayer:(CALayer *)layer below:(nullable CALayer *)sibling;
     
     - (void)insertSublayer:(CALayer *)layer above:(nullable CALayer *)sibling;
     
     - (void)replaceSublayer:(CALayer *)layer with:(CALayer *)layer2;
     ***/
    
    
    NSLog(@"star - %@", self.view.layer.sublayers);
    
    
    // CAReplicatorLayer
//    [self set6];
    
    // 设置 2D 或 3D 效果 -- 先暂时不考虑
//    [self set5];
    
    // 设置 layer 的阴影属性
//    [self set4];
    
    // 给 view 添加显示图片的图层
//    [self set3];
    
    // 创建一个显示图片的图层 -- 位置不能改变
    [self set2];
    
//    [self set1];
    
    NSLog(@"end - %@", self.view.layer.sublayers);
}

- (void)set6 {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(172, 200, 10, 10)];
    
    imageView.backgroundColor = [UIColor grayColor];
    
    imageView.layer.cornerRadius = 5;
    
    imageView.layer.masksToBounds = YES;
    
    imageView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    [self.view addSubview:imageView];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    
    replicatorLayer.bounds = self.view.bounds;
    
    
    replicatorLayer.position = self.view.center;
    
    replicatorLayer.preservesDepth = YES;
    
    [replicatorLayer addSublayer:imageView.layer];
    
    [self.view.layer addSublayer:replicatorLayer];
    
    
    CGFloat count = 100;
    
    replicatorLayer.instanceDelay = 1.0 / count;
    
    replicatorLayer.instanceCount = count;
    
    // 相对于 replicatorLayer.position 旋转
    replicatorLayer.instanceTransform = CATransform3DMakeRotation((2 * M_PI) / count, 0, 0, 1.0);
    
    
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = 1;
    
    animation.repeatCount = MAXFLOAT;
    
    animation.fromValue = @(1);
    
    animation.toValue = @(0.01);
    
    [imageView.layer  addAnimation:animation forKey:nil];
}

- (void)set5 {
    
    // 2D
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 200, 200)];
    
    view.backgroundColor = [UIColor purpleColor];
    
//    [self.view addSubview:view];
    
    view.transform = CGAffineTransformMakeTranslation(0, 50);
    
    
    // 3D
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 400, 200, 200)];
    
    view2.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:view2];
    
    // 分别对应 x y z 三个方向
    view2.layer.transform = CATransform3DMakeTranslation(100, 20, 0);
    
}

- (void)set4 {
    
    /****
    @property(nullable) CGColorRef shadowColor; // 阴影颜色
    
    @property float shadowOpacity;  // 透明度
    
     设置阴影的偏移量
     x  的正负 表示偏移方向
        正数：向右
        负数：向左
     y  的正负 表示上下的阴影
        正数：下面
        负数：上面
    @property CGSize shadowOffset;
    
    @property CGFloat shadowRadius; // 圆角
     
    @property(nullable) CGPathRef shadowPath;   // 路径阴影
    ****/
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(200, 50, 100, 100)];
    
    view3.backgroundColor = [UIColor greenColor];
    
    view3.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //  设置阴影的偏移量，如果是正数，则代表往右边偏移
    view3.layer.shadowOffset = CGSizeMake(15, -5);
    
    view3.layer.shadowOpacity = 0;
    
//    [self.view addSubview:view3];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    
    view.backgroundColor = [UIColor greenColor];
    
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //  设置阴影的偏移量，如果是正数，则代表往右边偏移
    view.layer.shadowOffset = CGSizeMake(15, 5);
    
    view.layer.shadowOpacity = 0.5;
    
//    [self.view addSubview:view];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(100, 450, 200, 200)];
    
    view2.backgroundColor = [UIColor greenColor];
    
    view2.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //  设置阴影的偏移量，如果是正数，则代表往右边偏移
    view2.layer.shadowOffset = CGSizeMake(-15, 5);
    
    view2.layer.shadowOpacity = 1;
    
//    [self.view addSubview:view2];
    
    
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    
    view4.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:view4];
    
    /**
     *  路径阴影
     */
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = view4.bounds.size.width;
    
    float height = view4.bounds.size.height;
    
    float x = view4.bounds.origin.x;
    
    float y = view4.bounds.origin.y;
    
    float addWH = 50;
    
    CGPoint topLeft      = view4.bounds.origin;
    
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    view4.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    
//    view4.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    
    view4.layer.shadowOpacity = 1;//阴影透明度，默认0
    
    view4.layer.shadowRadius = 3;//阴影半径，默认3
    
    // 不能添加 - 添加没有阴影显示
//    view4.layer.masksToBounds = YES;
    
}


- (void)set3 {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 200, 200 * 1334 / 750)];
    
    view.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:view];

    // 直接设置 View 的 layer 层， 不能直接给 view.layer 赋值
    view.layer.bounds = view.bounds;
    
    // 在 View 的图层上添加一个 image，congtens 表示接受内容
    view.layer.contents = (id)[UIImage imageNamed:@"IMG_0413.PNG"].CGImage;
    
    view.layer.cornerRadius = 10;
    
    view.layer.masksToBounds = YES;
    
    view.layer.borderWidth = 4;
    
    view.layer.borderColor = [UIColor blackColor].CGColor;
    
    view.layer.contentsScale = [UIScreen mainScreen].scale;
}

- (void)set2 {
    
    CALayer *redLayer = [CALayer layer];
    
    redLayer.backgroundColor = [UIColor redColor].CGColor;
    
    redLayer.bounds = CGRectMake(0, 0, 100, 100);
    
    redLayer.position = CGPointMake(170, 345);
    
//    redLayer.anchorPoint = CGPointMake(1, 1);
    
    
    
    
    
    
    CALayer *layer = [CALayer layer];
    
    layer.bounds = CGRectMake(0, 0, 100, 150);
    
    layer.position = CGPointMake(200, 300);
    
    layer.anchorPoint = CGPointMake(0.8, 0.2);
    
    
    
    layer.contents = (id)[UIImage imageNamed:@"IMG_0413.PNG"].CGImage;
    
    layer.cornerRadius = 10;
    
    layer.masksToBounds = YES;
    
    layer.borderWidth = 4;
    
    layer.borderColor = [UIColor blackColor].CGColor;
    
    layer.contentsScale = [UIScreen mainScreen].scale;
    
    [self.view.layer addSublayer:layer];
    
    [self.view.layer addSublayer:redLayer];
}


- (void)set1 {
    // 初始化方法
    //  对象方法
    CALayer *layer1 = [[CALayer alloc] init];
    //  类方法
    CALayer *layer2 = [CALayer layer];
    
    
    // 设置 layer 的属性（一定要设置位置，颜色才能显示出来）
    
    layer1.backgroundColor = [UIColor whiteColor].CGColor;
    
    layer1.bounds = CGRectMake(0, 0, 50, 50);   // bounds
    
    layer1.position = CGPointMake(100, 100);    // 中心位置
    
    
    
    
    layer2.backgroundColor = [UIColor brownColor].CGColor;
    
    layer2.bounds = CGRectMake(0, 0, 100, 100);
    
    layer2.position = CGPointMake(100, 100);
    
    
    // 把 layer 添加到界面上
    [self.view.layer addSublayer:layer2];
    
    [self.view.layer addSublayer:layer1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
