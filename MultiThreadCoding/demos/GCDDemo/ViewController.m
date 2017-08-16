//
//  ViewController.m
//  GCDDemo
//
//  Created by chao on 2016/10/25.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController





/**                 --GCD使用总结--
 *http://blog.csdn.net/u013321328/article/details/50512635
 *  派发队列分为两种：串行对列（SerialDispatchQueue），并行队列：（ConcurrentDispatchQueue）
 *  串行队列按顺序一个个执行，同时处理的任务只有一个
 *  并行队列可以同时执行多个任务，，，同时执行的任务数量取决于XNU内核，是不可控的，由系统控制
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1.将任务添加到队列中
//    dispatch_async(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)

    // 2.获取队列
    // 系统提供了两个队列，一个是MainDispatchQueue, 一个是GlobalDispatchQueue
    // MainDispachQueue队列 会将任务插入主线程的RunLoop中去执行，是一个串行队列，可用于刷新UI
    // GlobalDispatchQueue对列 是一个全局的并行队列，有高、默认、低、后台 4个优先级
    /*
     #define DISPATCH_QUEUE_PRIORITY_HIGH 2                 --高
     #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0              --默认
     #define DISPATCH_QUEUE_PRIORITY_LOW (-2)               --低
     #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN   --后台
     */
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 3.执行异步任务
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue1, ^{
        //...执行线程queue1
    });
    // 这个代码片直接在子线程里执行了一个任务块。只用GCD方式任务是立即开始执行的，不像操作队列那样可以手动启动，缺点是不可控
    
    
    // 4.整个工程只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //...只执行一次，可用于创建单例
    });
    

    /**         *任务组*
     *  有时候，我们希望多个任务同时（在多个线程里）执行，在他们都完成之后，再执行其他的任务，
     *　 于是可以建立一个分组，让多个任务形成一个组，下面的代码在组中多个任务都执行完毕之后再执行后续的任务：
     */
    dispatch_queue_t globalQueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t globalGroup1 = dispatch_group_create();
    
    dispatch_group_async(globalGroup1, globalQueue1, ^{ NSLog(@"异步1"); });
    dispatch_group_async(globalGroup1, globalQueue1, ^{ NSLog(@"异步2"); });
    dispatch_group_async(globalGroup1, globalQueue1, ^{ NSLog(@"异步3"); });
    dispatch_group_async(globalGroup1, globalQueue1, ^{ NSLog(@"异步4"); });
    dispatch_group_async(globalGroup1, globalQueue1, ^{ NSLog(@"异步5"); });
    
    
    dispatch_queue_t mainQueue1 = dispatch_get_main_queue();
    dispatch_group_t mainGroup1 = dispatch_group_create();
    
    dispatch_group_async(mainGroup1, mainQueue1, ^{ NSLog(@"顺序1"); });
    dispatch_group_async(mainGroup1, mainQueue1, ^{ NSLog(@"顺序2"); });
    dispatch_group_async(mainGroup1, mainQueue1, ^{ NSLog(@"顺序3"); });
    dispatch_group_async(mainGroup1, mainQueue1, ^{ NSLog(@"顺序4"); });
    dispatch_group_async(mainGroup1, mainQueue1, ^{ NSLog(@"顺序5"); });
    // globalGroup1任务组中的任务是同时执行的, 但是异步执行的任务是不可控的
    // mainGroup1任务组中的任务是按顺序执行的, 严格按照任务添加的顺序执行
    
    // 延迟执行任务
    dispatch_group_notify(globalGroup1, dispatch_get_main_queue(), ^{
        NSLog(@"time out done");
    });
    // 10s之后将任务插入RunLoop中
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"run after 10s");
    });
    
    
    /**         *异步dispatch_asych和 同步dispatch_sync*         **/
    dispatch_queue_t globalQueue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(globalQueue2, ^{
        NSLog(@"异步2_1");
    });
    
    NSLog(@"异步2_2");    // 这段代码会最先执行
    
    // 同步
    dispatch_queue_t globalQueue3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(globalQueue3, ^{  // 这里是全局队列
        NSLog(@"同步1");  // 当主线程将任务分给子线程之后，主线程会等待子线程执行完毕，再继续执行自身的内容
    });
    NSLog(@"同步2");
    
//    dispatch_queue_t mainQueue3 = dispatch_get_main_queue();
//    dispatch_sync(mainQueue3, ^{    // 这里是主线程队列     --循环等待导致死锁
//        NSLog(@"同步2_1");    //  主线程通过dispatch_sync把block交给主队列之后，会等待block里的任务结束后再往下走自身的任务
//                             //  队列是先进先出的，block里的任务也在等待主队列当中排在它之前的任务都执行完了再走自己           如此造成了循环等待
//    });
//    NSLog(@"同步2_2");
    
    /**         *手动创建串行和并行队列*           **/
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.Steak.GCD", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t myConcurrentDispatchQueue = dispatch_queue_create("com.Steak.GCD", DISPATCH_QUEUE_CONCURRENT);
    
    
    /**         *串行、并行队列与读写安全性*           **/
    dispatch_queue_t globalQueue4 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue4, ^{
        //读取数据1
    });
    dispatch_async(globalQueue4, ^{
        //读取数据2
    });
    dispatch_async(globalQueue4, ^{
        //数据写入
    });
    dispatch_async(globalQueue4, ^{
        //读取数据3
    });
    dispatch_async(globalQueue4, ^{
        //读取数据4
    });
    
    // 通过上面的分析可以知道这5个任务的执行顺序是不可控的，无法预期的，但如果我们希望在读取1和读取2执行结束之后再执行写入，写入完之后再执行读取3、4，就需要使用GCD的另一个API
    dispatch_barrier_async(globalQueue4, ^{ //保证了数据写入的并发安全性
        // 数据写入
    });
    // test
    dispatch_queue_t globalQueue5 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue5, ^{
        //读取数据1
        NSLog(@"数据读取1");
    });
    dispatch_async(globalQueue5, ^{
        //读取数据2
        NSLog(@"数据读取2");
    });
    dispatch_barrier_async(globalQueue5, ^{ // 一般情况下是按照预期的顺序执行的，也有时候会出现预期之外的顺序
        NSLog(@"数据写入");
    });
    dispatch_async(globalQueue5, ^{
        //读取数据3
        NSLog(@"数据读取3");
    });
    dispatch_async(globalQueue5, ^{
        //读取数据4
        NSLog(@"数据读取4");
    });
    
    // 对于没有数据竞争的并行操作，可以使用并行队列（CONCURRENT）来实现
    dispatch_queue_t globalQueue6 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t globalGroup6 = dispatch_group_create();
    
    dispatch_group_async(globalGroup6, globalQueue6, ^{
        sleep(0.5);
        NSLog(@"global6_1");
    });
    
    dispatch_group_async(globalGroup6, globalQueue6, ^{
        sleep(1.5);
        NSLog(@"global6_2");
    });
    
    dispatch_group_async(globalGroup6, globalQueue6, ^{
        sleep(2.5);
        NSLog(@"global6_3");
    });
    
    NSLog(@"aaaaaa");
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    if (dispatch_group_wait(globalGroup6, time) == 0) {
        NSLog(@"已经全部执行完毕");
    }
    else {
        NSLog(@"没有执行完毕");
    }
    
    NSLog(@"bbbbbb");
    /*
     这里起了3个异步线程放在一个组里，之后通过dispatch_time_t创建了一个超时时间（2秒），程序之后行，立即输出了aaaaa，这是主线程输出的，当遇到dispatch_group_wait时，主线程会被挂起，等待2秒，在等待的过程当中，子线程分别输出了1和2，2秒时间达到后，主线程发现组里的任务并没有全部结束，然后输出了bbbbb。
     　　在这里，如果超时时间设置得比较长（比如5秒），那么会在2.5秒时第三个任务结束后，立即输出bbbbb，也就是说，当组中的任务全部执行完毕时，主线程就不再被阻塞了。
     */
    
    // 并行循环
    dispatch_queue_t globalQueue7 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 三个参数：循环次数， 循环队列， 第几次循环
    dispatch_apply(MAXFLOAT, globalQueue7, ^(size_t i) {
        NSLog(@"%lu", i);
    });
    
    // 暂停和恢复 指定的dispatch_queue
    // 暂停 dispatch_suspend(<#dispatch_object_t  _Nonnull object#>)
    // 恢复 dispatch_resume(<#dispatch_object_t  _Nonnull object#>)
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
