//
//  M8FloatWindowController.m
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8FloatWindowController.h"
#import "M8FloatRenderView.h"
#import "M8FloatWindowSingleton.h"

#define kFloatWindowSize CGSizeMake(60, 80)

@interface M8FloatWindowController ()<FloatRenderViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) M8FloatRenderView *renderView;



@end

@implementation M8FloatWindowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // hide the root view
    self.view.frame = [UIScreen mainScreen].bounds;
    CGRect frame = self.view.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.view.frame = frame;
    self.view.backgroundColor = [UIColor redColor];
    // create floating window renderView
    [self createRenderView];
    // register UIDeviceOrientationDidChangeNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.renderView.hidden = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 300, 100, 50);
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(showRenderView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)showRenderView {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        self.renderView.hidden = NO;
    }];
}

- (void)hiddeRenderView {
    self.renderView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)createRenderView {
    // 1. floating render view
    M8FloatRenderView *renderView = [[M8FloatRenderView alloc] init];
    renderView.contentMode = UIViewContentModeScaleAspectFill;
    renderView.frame = CGRectMake(0, 0, kFloatWindowSize.width, kFloatWindowSize.height);
    renderView.WCDelegate = self;
    renderView.initOrientation = [UIApplication sharedApplication].statusBarOrientation;
    renderView.originTransform = renderView.transform;
    renderView.alpha = 0.8;
    
    // 2. floating window
    UIWindow *window = [[UIWindow alloc] init];
    window.frame = CGRectMake(0, 0, kFloatWindowSize.width, kFloatWindowSize.height);
    window.windowLevel = UIWindowLevelAlert + 1;
    window.backgroundColor = [UIColor clearColor];
    [window addSubview:renderView];
    [window makeKeyAndVisible];
    
    _renderView = renderView;
    _window     = window;
}



/**
 set rootView for renderView
 */
- (void)setRootView {
    _renderView.rootView = self.view.superview;
}

- (void)floatRenderViewDidClicked {
    NSLog(@"render view did be clicked");
    [self hiddeRenderView];
}

- (void)setWindowHide:(BOOL)hide {
    _window.hidden = hide;
}

- (void)setWindowSize:(CGSize)size {
    CGRect frame = _window.frame;
    _window.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
    _window.frame = CGRectMake(0, 0, size.width, size.height);
    [self.view setNeedsLayout];
}


- (void)orientationChange:(NSNotification *)notification {
    [_renderView renderViewRotate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
