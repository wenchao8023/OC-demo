//
//  UIViewController2.m
//  GCDDemo
//
//  Created by chao on 2017/3/22.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "UIViewController2.h"

#define GCD_QUEUE_CONNECT dispatch_queue_create("com.connect.GCD", DISPATCH_QUEUE_SERIAL)

#define GCD_QUEUE_WRITE   dispatch_queue_create("com.writeData.GCD", DISPATCH_QUEUE_CONCURRENT)

#define GCD_QUEUE_READ    dispatch_queue_create("com.readData.GCD", DISPATCH_QUEUE_CONCURRENT)


//#define GCD_QUEUE_aaaaaa    dispatch_queue_create("com.aaaaaa.GCD", DISPATCH_QUEUE_CONCURRENT)
//
//#define GCD_QUEUE_bbbbbb    dispatch_queue_create("com.bbbbbb.GCD", DISPATCH_QUEUE_CONCURRENT)



@interface UIViewController2 () {
    
    dispatch_queue_t GCD_QUEUE_aaaaaa;
    
    dispatch_queue_t GCD_QUEUE_bbbbbb;
    
    dispatch_group_t GCD_GROUP_cccccc;
    
    int _testNum;
    
    
}

@property (nonatomic, strong) NSThread *cutThread;

@end

@implementation UIViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GCD_QUEUE_aaaaaa  =  dispatch_queue_create("com.aaaaaa.GCD", DISPATCH_QUEUE_CONCURRENT);
    GCD_QUEUE_bbbbbb  =  dispatch_queue_create("com.bbbbbb.GCD", DISPATCH_QUEUE_CONCURRENT);
    
    GCD_GROUP_cccccc  =  dispatch_group_create();
    
    // Do any additional setup after loading the view.
    
//    dispatch_async(GCD_QUEUE_CONNECT, ^{
//       
//        NSLog(@"GCD_QUEUE_CONNECT read  data 1");
//    });
//    
//    dispatch_async(GCD_QUEUE_CONNECT, ^{
//        
//        NSLog(@"GCD_QUEUE_CONNECT read  data 2");
//    });
//    
//    dispatch_barrier_async(GCD_QUEUE_CONNECT, ^{
//        
//        NSLog(@"GCD_QUEUE_CONNECT write data 3");
//    });
//    
//    dispatch_async(GCD_QUEUE_CONNECT, ^{
//        
//        NSLog(@"GCD_QUEUE_CONNECT read  data 4");
//    });
//    
//    dispatch_async(GCD_QUEUE_CONNECT, ^{
//        
//        NSLog(@"GCD_QUEUE_CONNECT read  data 5");
//    });
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.frame = CGRectMake(100, 100, 100, 100);
    
    button.backgroundColor = [UIColor blueColor];
    
    [button setTitle:@"button1" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(showPrint) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button2.frame = CGRectMake(100, 300, 100, 100);
    
    button2.backgroundColor = [UIColor blueColor];
    
    [button2 setTitle:@"button2" forState:UIControlStateNormal];
    
    [button2 addTarget:self action:@selector(showPrint2) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button3.frame = CGRectMake(250, 200, 100, 100);
    
    button3.backgroundColor = [UIColor cyanColor];
    
    [button3 setTitle:@"button3" forState:UIControlStateNormal];
    
    [button3 addTarget:self action:@selector(showPrint3) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button4.frame = CGRectMake(250, 400, 100, 100);
    
    [button4 setTitle:@"button1" forState:UIControlStateNormal];
    
    button4.backgroundColor = [UIColor cyanColor];
    
    [button4 addTarget:self action:@selector(showPrint4) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button4];
}

-(void)showPrint4 {
    
    dispatch_group_async(GCD_GROUP_cccccc, GCD_QUEUE_aaaaaa, ^{
        
        if (_cutThread)
            [[self.cutThread class] sleepUntilDate:[NSDate distantPast]];
        else
            [self.cutThread start];
    });
}

-(NSThread *)cutThread {
    
    if (!_cutThread) {
        _cutThread = [[NSThread alloc] initWithTarget:self selector:@selector(cutNum) object:nil];
        
        _cutThread.name = @"cut thread";
    }
    
    return _cutThread;
}

-(void)cutNum {
    
    while (1) {
        
        [NSThread sleepForTimeInterval:1.0];
        
        NSLog(@"number = : %d, currentThread : %@", _testNum, [NSThread currentThread]);
        
        while (_testNum == 0) {
            
            NSLog(@"before wait");
            
            [NSThread sleepUntilDate:[NSDate distantFuture]];
            
            NSLog(@"after wait");
        }
    }
}


-(void)showPrint3 {

    _testNum = 10;
//    dispatch_async(GCD_QUEUE_aaaaaa, ^{
//        
//        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(print3) object:nil];
//        
//        [thread setName:@"thread control"];
//        
//        [thread start];
//    });
//    
//    dispatch_async(GCD_QUEUE_aaaaaa, ^{
//        
//        NSLog(@"currentThread : %@", [NSThread currentThread]);
//    });
}

-(void)print3 {

    NSLog(@"currentQueue : %@, \ncurrentThread : %@", [NSOperationQueue currentQueue], [NSThread currentThread]);
}

-(void)showPrint2 {
    
    _testNum--;
//    NSLog(@"main queue data 1");
//    
//    dispatch_async(GCD_QUEUE_aaaaaa, ^{
//        
//        NSLog(@"GCD_QUEUE_aaaaaa 1 : %@", [NSThread currentThread]);
//        
//        dispatch_async(GCD_QUEUE_bbbbbb, ^{
//            NSLog(@"GCD_QUEUE_bbbbbb 1 : %@", [NSThread currentThread]);
//            
//            CFRunLoopRun();
//            
//            NSLog(@"run loop");
//            
//            dispatch_async(GCD_QUEUE_aaaaaa, ^{
//                NSLog(@"GCD_QUEUE_aaaaaa 2 : %@", [NSThread currentThread]);
//                
//                dispatch_async(GCD_QUEUE_bbbbbb, ^{
//                    NSLog(@"GCD_QUEUE_bbbbbb 2 : %@", [NSThread currentThread]);
//                    
//                    NSLog(@"end...");
//                });
//            });
//        });
//       
//    });
    
//    dispatch_async(GCD_QUEUE_aaaaaa, ^{
//        
//        NSLog(@"GCD_QUEUE_aaaaaa read  data 2");
//    });
//    
//    dispatch_async(GCD_QUEUE_aaaaaa, ^{
//        
//        NSLog(@"GCD_QUEUE_aaaaaa write data 3");
//    });
//    
//    dispatch_async(GCD_QUEUE_aaaaaa, ^{
//        
//        NSLog(@"GCD_QUEUE_aaaaaa read  data 4");
//    });
//    
//    dispatch_async(GCD_QUEUE_aaaaaa, ^{
//        
//        NSLog(@"GCD_QUEUE_aaaaaa read  data 5");
//    });
    
//    NSLog(@"main queue data 2");
//    
////    dispatch_async(dispatch_get_main_queue(), ^{
//        dispatch_suspend(GCD_QUEUE_aaaaaa);
////        NSLog(@"GCD_QUEUE_bbbbbb read  data 2");
////    });
//    
//    dispatch_async(GCD_QUEUE_bbbbbb, ^{
//       
//        NSLog(@"GCD_QUEUE_bbbbbb read  data 1");
//        
//        
//        
//        NSLog(@"GCD_QUEUE_bbbbbb read  data 3");
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            NSLog(@"GCD_QUEUE_bbbbbb read  data 4");
//            
//            dispatch_resume(GCD_QUEUE_aaaaaa);
//            
//            NSLog(@"GCD_QUEUE_bbbbbb read  data 5");
//        });
//    });
//    
//    NSLog(@"main queue data 3");
}


-(void)showPrint {
    
    dispatch_group_async(GCD_GROUP_cccccc, GCD_QUEUE_aaaaaa, ^{
        [self cutNum];
    });
//    NSLog(@"main queue data 1");
//    
//    dispatch_async(GCD_QUEUE_WRITE, ^{
//        
//        NSLog(@"GCD_QUEUE_WRITE read  data 1");
//    });
//    
//    dispatch_async(GCD_QUEUE_WRITE, ^{
//        
//        NSLog(@"GCD_QUEUE_WRITE read  data 2");
//    });
//    
//    dispatch_barrier_async(GCD_QUEUE_WRITE, ^{
//        
//        NSLog(@"GCD_QUEUE_WRITE write data 3");
//    });
//    
//    dispatch_async(GCD_QUEUE_WRITE, ^{
//        
//        NSLog(@"GCD_QUEUE_WRITE read  data 4");
//    });
//    
//    dispatch_async(GCD_QUEUE_WRITE, ^{
//        
//        NSLog(@"GCD_QUEUE_WRITE read  data 5");
//    });
    
//    dispatch_sync(GCD_QUEUE_WRITE, ^{
//        
//        NSLog(@"GCD_QUEUE_WRITE read  data 6");
//    });
    
//    NSLog(@"main queue data 2");
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
