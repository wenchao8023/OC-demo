//
//  ViewController.m
//  NSThread-demo
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//





/*
 ** NSThread **
 实现多线程的技术方案之一.
 面向对象的开发思想.
 每个对象表示一条线程.
 */
#import "ViewController.h"

#import "Person.h"


@interface ViewController ()

@property (nonatomic, strong) Person *person;

@property (nonatomic, assign) NSInteger tickets;

// 非原子属性
@property (nonatomic, strong) NSObject *obj1;
// 原子属性：内部有“自旋锁”
@property (atomic, strong) NSObject *obj2;
// 模拟原子属性
@property (atomic, strong) NSObject *obj3;


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController
// 合成指令
@synthesize obj3 = _obj3;
/// obj3的setter方法
-(void)setObj3:(NSObject *)obj3 {
    @synchronized (self) {
        _obj3 = obj3;
    }
}
/// obj3的getter方法
-(NSObject *)obj3 {
    
    return _obj3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self createThread];
//    
//    [self testPersonDemo];
    
//    [self threadShuxing];
    
//    [self testSaleTickets];
    
//    [self testAtomic];
    
    [self testDownloadImage];
}

#pragma mark - testDownloadImage
-(void)testDownloadImage {
    
    [self loadView];
    
    [self performSelectorInBackground:@selector(downloadImageData) withObject:nil];
}

-(void)loadView {
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 将滚动视图设置成根视图
    self.view = self.scrollView;
    self.scrollView.backgroundColor = [UIColor redColor];
    
    // 创建图片视图
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    self.imageView = imageView;
}

-(void)downloadImageData {
    // 图片资源地址
    NSURL *url = [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/c995d143ad4bd1130c0ee8e55eafa40f4afb0521.jpg"];
    // 所有的网络数据都是以二进制的形式传输的,所以用NSData来接受
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    // 设置图片视图
    // [self setupImageViewWithImage:image];
    
    // 回到主线程更新UI
    // waitUntilDone:是否等待主线程执行结束再执行"下一行代码",一般设置成NO,不用等待
    [self performSelectorOnMainThread:@selector(setupImageViewWithImage:) withObject:image waitUntilDone:NO];
    
    // 测试 waitUntilDone:
    NSLog(@"下一行代码");
}

-(void)setupImageViewWithImage:(UIImage *)image {
    NSLog(@"setupImageView");
    
    // 设置图片视图
    self.imageView.image = image;
    // 设置图片视图的大小跟图片一般大
    [self.imageView sizeToFit];
    
    // 设置滚动视图的滚动:滚动范围跟图片一样大
    [self.scrollView setContentSize:image.size];
}


#pragma mark - testAtomic
-(void)testAtomic {
    NSInteger largeNum = 1000*1000;
    
    NSLog(@"非原子属性");
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < largeNum; i++) {
        self.obj1 = [[NSObject alloc] init];
    }
    NSLog(@"非原子属性 => %f",CFAbsoluteTimeGetCurrent()-start);
    
    NSLog(@"原子属性");
    start = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < largeNum; i++) {
        self.obj2 = [[NSObject alloc] init];
    }
    NSLog(@"原子属性 => %f",CFAbsoluteTimeGetCurrent()-start);
    
    NSLog(@"模拟原子属性");
    start = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < largeNum; i++) {
        self.obj3 = [[NSObject alloc] init];
    }
    NSLog(@"模拟原子属性 => %f",CFAbsoluteTimeGetCurrent()-start);
    
    /*
     互斥锁和自旋锁对比
     
     共同点
     
     都能够保证同一时间,只有一条线程执行锁定范围的代码
     不同点
     
     互斥锁:如果发现有其他线程正在执行锁定的代码,线程会进入休眠状态,等待其他线程执行完毕,打开锁之后,线程会重新进入就绪状态.等待被CPU重新调度.
     自旋锁:如果发现有其他线程正在执行锁定的代码,线程会以死循环的方式,一直等待锁定代码执行完成.
     开发建议
     
     所有属性都声明为nonatomic,原子属性和非原子属性的性能几乎一样.
     尽量避免多线程抢夺同一块资源.
     要实现线程安全,必须要用到锁.无论什么锁,都是有性能消耗的.
     自旋锁更适合执行非常短的代码.死循环内部不适合写复杂的代码.
     尽量将加锁,资源抢夺的业务逻辑交给服务器端处理,减小移动客户端的压力.
     为了流畅的用户体验,UIKit类库的线程都是不安全的,所以我们需要在主线程(UI线程)上更新UI.
     所有包含NSMutable的类都是线程不安全的.在做多线程开发的时候,需要注意多线程同时操作可变对象的线程安全问题.
     */
}

#pragma mark - testSaleTickets
-(void)testSaleTickets {
    
    self.tickets = 20;
    
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketsWithLock) object:nil];
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketsWithLock) object:nil];
    
//    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketsWithNOLock) object:nil];
//    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketsWithNOLock) object:nil];
    
    [thread1 setName:@"售票口 A"];
    
    [thread1 start];
    
    [thread2 setName:@"售票口 B"];
    
    [thread2 start];
}

-(void)saleTicketsWithLock {
    
    while (YES) {
        
//        [NSThread sleepForTimeInterval:1.0];
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        
        // 添加互斥锁
        @synchronized (self) {
            if (self.tickets > 0) {
                self.tickets--;
                NSLog(@"%@, 剩余票数 => %zd", [NSThread currentThread].name, self.tickets);
            }else {
                NSLog(@"没票了。。。");
                break;
            }
        }
    }
    
    /** 互斥锁小结
     *  互斥锁,就是使用了线程同步技术.
     *  同步锁/互斥锁:可以保证被锁定的代码,同一时间,只能有一个线程可以操作.
     *  self :锁对象,任何继承自NSObject的对像都可以是锁对象,因为内部都有一把锁,而且默认是开着的.
     *  锁对象 : 一定要是全局的锁对象,要保证所有的线程都能够访问,self是最方便使用的锁对象.
     *  互斥锁锁定的范围应该尽量小,但是一定要锁住资源的读写部分.
     *  加锁后程序执行的效率比不加锁的时候要低.因为线程要等待解锁.
     *  牺牲了性能保证了安全性.
     */
}

-(void)saleTicketsWithNOLock {
 
    while (YES) {
        
        [NSThread sleepForTimeInterval:1.0];
//        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        

            if (self.tickets > 0) {
                self.tickets--;
                NSLog(@"%@, 剩余票数 => %zd", [NSThread currentThread].name, self.tickets);
            }else {
                NSLog(@"没票了。。。");
                break;
            }

    }
}

#pragma mark - threadShuxing
-(void)threadShuxing {
    
    /** 线程属性
     *
     ** name - 线程名称
     *  给线程起名字,可以方便运行调试,定位BUG
     *  在大型的商业软件中,都会设计专门的线程做特定的事情,当程序崩溃时可以快速准确的定位BUG
     *
     ** threadPriority - 线程优先级
     *  为浮点数整形,范围在0~1之间,1最高,默认0.5,不建议修改线程优先级
     *  线程的"优先级"不是决定线程调用顺序的,他是决定线程备CPU调用的频率的
     *  在开发的时候,不要修改优先级
     *  多线程开发的原则是越简单越好
     *
     ** stackSize - 栈区大小
     *  默认情况下,无论是主线程还是子线程,栈区大小都是512KB
     *  栈区大小可以设置,最小16KB,但是必须是4KB的整数倍
     **/
    
    /** 【补充】
     *  NSInteger 有符号整数(有正负数)用 %zd
     *  NSUInteger 无符号整数(没有负数)用 %tu
     *  是为了自适应32位和64位CPU的架构.
     **/
    
    NSLog(@"主线程栈区空间大小 => %tu",[NSThread currentThread].stackSize/1024);
    
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(testShuxing) object:nil];
    
    [thread1 setName:@"download A"];
    
    [thread1 setThreadPriority:1.0];
    
    [thread1 start];
    
    
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(testShuxing) object:nil];
    
    [thread2 setName:@"download B"];
    
    [thread2 setThreadPriority:0];
    
    [thread2 start];
}
-(void)testShuxing {
     NSLog(@"子线程栈区空间大小 => %tu",[NSThread currentThread].stackSize/1024);
    
    for (int i = 0; i < 10; i++) {
        
        if (i == 5 && [[NSThread currentThread].name isEqualToString:@"download B"]) {
            
            return ;
        }
        
        NSLog(@"current thread is : %@", [NSThread currentThread]);
    }
}

#pragma mark - exit()
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 新建状态
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadDemo) object:nil];
    
    // 就绪状态 : 将线程放进 "可调度线程池", 等待被CPU调度
    [thread start];
    
    // 主线程中的危险操作，不能在主线程中调用该方法，会使主线程退出
//    [NSThread exit];
    
}


/** 关于exit的结论 **
 *  使当前线程退出.
 *  不能在主线程中调用该方法.会使主线程退出.
 *  当当前线程死亡之后,这个线程中的代码都不会被执行.
 *  在调用此方法之前一定要注意释放之前由C语言框架创建的对象.
 **/

-(void)threadDemo {
    
    for (int i = 0; i < 6; i++) {
        
        NSLog(@"%d",i);
        
        //1. 当前线程,每循环一次,就休眠一秒
        [NSThread sleepForTimeInterval:1.0];
        
        //2. 满足某一条件再次休眠一秒
        if (2==i) {
            NSLog(@"我还想再睡一秒");
            // 休眠时间为从现在开始计时多少秒以后
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        }
        
        //3. 满足某一条件线程死亡
        if (4==i) {
            NSLog(@"线程死亡");
            
            // 在调用exit方法之前一定要注意释放之前由C语言框架创建的对象.
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathRelease(path);
            
            // 线程死亡
            [NSThread exit];
            
            // 当线程死亡之后,以后的代码都不会被执行
            NSLog(@"线程已经死亡");
        }
    }
    NSLog(@"循环结束");
}

#pragma mark - testPersonDemo
-(void)testPersonDemo {
    
    [self.person performSelectorInBackground:@selector(personDemo:) withObject:@"perform"];
    
    [NSThread detachNewThreadSelector:@selector(personDemo:) toTarget:self.person withObject:@"detach"];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self.person selector:@selector(personDemo:) object:@"alloc"];
    
    [thread setName:@"person"];
    
    [thread start];
}

-(Person *)person {
    
    if (!_person) {
        _person = [Person personWithName:@"chaoge"];
    }
    
    return _person;
}

#pragma mark - createThread
-(void)createThread {
    
    // 创建线程对象
    [self createThread1];
    
    [self createThread2];
    
    [self createThread3];
}

-(void)createThread1 {
    
    //1.实例化创建线程
    //  需要手动开启线程
    
    /*** 内存中创建一个线程对象 ***/
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(demo:) object:@"alloc"];
    
    [thread setName:@"我要控记你"];
    
    /*** 将线程放进可调度线程池，等待被CPU调度 
        1. CPU负责调度"可调度线程池"中的处于"就绪状态"的线程
        2. 线程执行结束之前,状态可能会在"就绪"和"运行"之间来回的切换
        3. "就绪"和"运行"之间的状态切换由CPU来完成,程序员无法干涉
     ***/
    
    [thread start];
}

-(void)createThread2 {
    
    //2.分离出一个线程，并且自动开启线程执行@selector(demo:)
    //  无法获取到对象
    [NSThread detachNewThreadSelector:@selector(demo:) toTarget:self withObject:@"detach"];
}

-(void)createThread3 {
    
    //3.NSObject(NSThreadPerformAdditions)的分类创建
    //  无法获取到线程对象
    //  自动开启线程执行@selector(demo:)
    //  方便任何继承自NSObject的对象，都可以很容易的调用线程方法
    [self performSelectorInBackground:@selector(demo:) withObject:@"perform"];
}


-(void)demo:(id)obj {
    NSLog(@"传入参数 => %@", obj);
    NSLog(@"currentThread is : %@", [NSThread currentThread]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
