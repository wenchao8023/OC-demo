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
    
    /**
     *  UIImage有一个CGImage属性，它返回一个"CGImageRef"
     *  如果把这个值直接赋值给CALayer的contents，将会得到一个编译错误 
     *  -- 因为CGImageRef并不是一个真正的Cocoa对象，而是一个Core Foundation类型。
     *  可以通过bridged关键字转换
     *  -- 如果没有使用ARC（自动引用计数），就不需要 __bridge 这部分
     */
    self.layerView.layer.contents = (__bridge id)image.CGImage;
    
    // layer.contentsGravity 属性 等价于 view.contentMode 属性
    self.layerView.layer.contentsGravity = kCAGravityResizeAspect;
    
    
    /******* contentsGravity **********
     **
         kCAGravityCenter
         kCAGravityTop
         kCAGravityBottom
         kCAGravityLeft
         kCAGravityRight
         kCAGravityTopLeft
         kCAGravityTopRight
         kCAGravityBottomLeft
         kCAGravityBottomRight
         kCAGravityResize
         kCAGravityResizeAspect
         kCAGravityResizeAspectFill
     **
     */
    
    /******* contentMode    **********
     **
         UIViewContentModeScaleToFill,
         UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
         UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
         UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
         UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
         UIViewContentModeTop,
         UIViewContentModeBottom,
         UIViewContentModeLeft,
         UIViewContentModeRight,
         UIViewContentModeTopLeft,
         UIViewContentModeTopRight,
         UIViewContentModeBottomLeft,
         UIViewContentModeBottomRight,
     **
     */
    
    /**
     *  contentsScale属性
     *  -- 定义了寄宿图的像素尺寸和视图大小的比例，默认情况下它是一个值为1.0的浮点数
     *  类似于 _layerView.contentScaleFactor 属性
     */
    self.layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    
    /**
     *  masksToBounds属性
     *  -- 用来决定是否显示超出边界的内容
     *  类似于 _layerView.clipsToBounds 属性
     */
    self.layerView.layer.masksToBounds = YES;
    
    /**
     *  contentsRect属性  默认是{0, 0, 1, 1}
     *  -- 允许在图层边框里显示寄宿图的一个子域
     *  和bounds，frame不同，contentsRect不是按点来计算的，它使用了单位坐标，单位坐标指定在0到1之间，是一个相对值（像素和点就是绝对值）
     */
    
    /** iOS使用了以下的坐标系统：**
     *  点 —— 在iOS和Mac OS中最常见的坐标体系。点就像是虚拟的像素，也被称作逻辑像素。在标准设备上，一个点就是一个像素，但是在Retina设备上，一个点等于2*2个像素。iOS用点作为屏幕的坐标测算体系就是为了在Retina设备和普通设备上能有一致的视觉效果。
     *  像素 —— 物理像素坐标并不会用来屏幕布局，但是仍然与图片有相对关系。UIImage是一个屏幕分辨率解决方案，所以指定点来度量大小。但是一些底层的图片表示如CGImage就会使用像素，所以你要清楚在Retina设备和普通设备上，他们表现出来了不同的大小。
     *  单位 —— 对于与图片大小或是图层边界相关的显示，单位坐标是一个方便的度量方式， 当大小改变的时候，也不需要再次调整。单位坐标在OpenGL这种纹理坐标系统中用得很多，Core Animation中也用到了单位坐标。*
     */
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
