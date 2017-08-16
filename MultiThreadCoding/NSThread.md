# iOS多线程--NSThread

## 1. NSThread介绍
NSThread是苹果官方提供的，使用起来比pthread更加面向对象，简单易用，可以直接操作线程对象。不过也需要需要程序员自己管理线程的生命周期(主要是创建)，我们在开发的过程中偶尔使用NSThread。比如我们会经常调用[NSThread currentThread]来显示当前的进程信息。

## 2. NSThread使用

### 2.1 创建、启动线程

* 先创建线程，再启动线程

```
NSThread *thread = [[NSThread alloc] initWithTarget:self
selector:@selector(run) object:nil];
[thread start];    // 线程一启动，就会在线程thread中执行self的run方法
```

* 创建线程后自动启动线程

```
[NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
```

* 隐式创建并启动线程

`[self performSelectorInBackground:@selector(run) withObject:nil];`

### 2.3 线程的方法调用

```
// 获得主线程
+ (NSThread *)mainThread;  

// 判断是否为主线程(对象方法)
- (BOOL)isMainThread;

// 判断是否为主线程(类方法)
+ (BOOL)isMainThread;    

// 获得当前线程
NSThread *current = [NSThread currentThread];

// 线程的名字——setter方法
- (void)setName:(NSString *)n;    

// 线程的名字——getter方法
- (NSString *)name;
```

### 2.4 线程的状态转换

当我们新建一条线程NSThread `thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];`，在内存中的表现为：
![new thread](http://upload-images.jianshu.io/upload_images/1877784-557cafe9005287bf.png?imageMogr2/auto-orient/strip%7CimageView2/2)

当调用`[thread start];`后，系统把线程对象放入可调度线程池中，线程对象进入就绪状态，如下图所示。
![thread new](http://upload-images.jianshu.io/upload_images/1877784-60021d1165ba05d1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当然，可调度线程池中，会有其他的线程对象，如下图所示。在这里我们只关心左边的线程对象。
![thread keyong](http://upload-images.jianshu.io/upload_images/1877784-7c39f9d019cea9ff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



**下边我们来看看当前线程的状态转换。**

* 如果CPU现在调度当前线程对象，则当前线程对象进入运行状态，如果CPU调度其他线程对象，则当前线程对象回到就绪状态。
* 如果CPU在运行当前线程对象的时候调用了sleep方法\等待同步锁，则当前线程对象就进入了阻塞状态，等到sleep到时\得到同步锁，则回到就绪状态。
* 如果CPU在运行当前线程对象的时候线程任务执行完毕\异常强制退出，则当前线程对象进入死亡状态。

当前线程对象的状态变化如下图所示。
![thread statuchange](http://upload-images.jianshu.io/upload_images/1877784-18eab813719d579d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 2.5 线程互斥锁
@synchronized(锁对象) { // 需要锁定的代码  }

注意：锁定1份代码只用1把锁，用多把锁是无效的

互斥锁的优缺点
优点：能有效防止因多线程抢夺资源造成的数据安全问题
缺点：需要消耗大量的CPU资源

互斥锁的使用前提：多条线程抢夺同一块资源

相关专业术语：线程同步
线程同步的意思是：多条线程按顺序地执行任务
互斥锁，就是使用了线程同步技术

### 2.6 原子性和非原子性
OC在定义属性时有nonatomic和atomic两种选择
atomic：原子属性，为setter方法加锁（默认就是atomic）
nonatomic：非原子属性，不会为setter方法加锁

atomic加锁原理

```
@property (assign, atomic) int age;
- (void)setAge:(int)age  
{  
    @synchronized(self) {  
        _age = age;  
    }  
} 
```
nonatomic和atomic对比
atomic：线程安全，需要消耗大量的资源
nonatomic：非线程安全，适合内存小的移动设备

iOS开发的建议
所有属性都声明为nonatomic
尽量避免多线程抢夺同一块资源
尽量将加锁、资源抢夺的业务逻辑交给服务器端处理，减小移动客户端的压力

### 2.7 线程间通信
在1个进程中，线程往往不是孤立存在的，多个线程之间需要经常进行通信

线程间通信的体现
1个线程传递数据给另1个线程
在1个线程中执行完特定任务后，转到另1个线程继续执行任务

线程间通信常用方法

```
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;  
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait;  
```
线程间通信示例 – 图片下载
![image download](http://img.blog.csdn.net/20150510085156453?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvc2luYXRfMjc3MDY2OTc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)


## 3 实例介绍
业务描述（卖票）： 模拟两个线程抢夺一份资源

运行结果图：

![demo show](http://img.blog.csdn.net/20150510091122012?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvc2luYXRfMjc3MDY2OTc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

主要代码说明：

* 属性及方法定义：

```
/*
    1. NSThread 可以使用NSLock 进行加锁工作 
    2. NSOperation和GCD  应该使用同步锁 ：@synchronized(self)，并且抢夺的内存资源应该定义为 atomic 的属性 
 */
@property (atomic,assign) int tickets;  
@property (atomic,strong) NSLock *lock;  
//  显示结果区域  
@property (weak, nonatomic) IBOutlet UITextView *messageBoard;  
//  开始售票  
- (IBAction)threadSale;  
```

* 点击Start对应方法的代码：

```
- (IBAction)threadSale {  
    // 1. 先设定销售票的数量  
    _tickets = 100;  
      
    // 创建线程1  
    NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(threadSaleMethod) object:nil];  
    // 便于跟踪时知道谁在工作  
    thread1.name = @"售票线程-1";  
    // 启动线程  
    [thread1 start];  
      
    // 创建线程2  
    NSThread *thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(threadSaleMethod) object:nil];  
    thread2.name = @"售票线程-2";  
    [thread2 start];  
} 
```

* 子线程执行内容对应的方法

```
- (void)threadSaleMethod {  
    // 1. 定义锁，懒加载  
    if (_lock == nil) {  
        _lock = [[NSLock alloc] init];  
    }  
      
    while(YES)  
    {  
        [_lock lock];  
        if(_tickets > 0)  
        {  
            NSString *message = [NSString stringWithFormat:@"当前票数是%d，售票线程是%@",_tickets,[[NSThread currentThread] name]];  
            // 更新UI的工作，一定要放在主线程中完成  
            // waitUntilDone 的意思是：是否等待主线程更新完毕  
            [self performSelectorOnMainThread:@selector(appendTextView:) withObject:message waitUntilDone:YES];  
              
            _tickets--;  
              
            // 当前线程执行完毕，解锁  
            [_lock unlock];  
  
            // 模拟延时  
            if ([[[NSThread currentThread] name] isEqualToString:@"售票线程-1"]) {  
                [NSThread sleepForTimeInterval:0.2];  
            } else {  
                [NSThread sleepForTimeInterval:0.3];  
            }  
        }  
        else{  
            // 在退出之前需要解锁  
            [_lock unlock];  
              
            // 结束信息  
            NSString *str = [NSString stringWithFormat:@"票已售完%@", [[NSThread currentThread] name]];  
            [self performSelectorOnMainThread:@selector(appendTextView:) withObject:str waitUntilDone:YES];  
              
            break;  
  
        }  
    }  
}  
```

* 更新主线程UI对应的方法

```
- (void)appendTextView:(NSString *)text {  
    NSMutableString *str = [NSMutableString stringWithString:self.messageBoard.text];  
    [str appendFormat:@"\n%@", text];  
      
    self.messageBoard.text = str;  
      
    // 用来将文本框滚动到想要的位置  
    // 我们现在想要滚动到最后，这个方法的参数是一个NSRange  
    NSRange range = NSMakeRange(str.length, 1);  
    [self.messageBoard scrollRangeToVisible:range];  
}  
```