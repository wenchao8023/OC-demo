# 断言（NSAssert）的用法


### NSAssert()介绍

* NSAssert()是一个宏，用于开发阶段调试程序中的Bug，通过为NSAssert()传递条件表达式来断定是否属于Bug，满足条件返回真值，程序继续运行，如果返回假值，则抛出异常，并且可以自定义异常描述。

* NSAssert() 定义

	`#define NSAssert(condition, desc)`
	
	> condition是条件表达式，值为YES或NO
	>
	> desc为异常描述，通常为NSString
	>
	> 当conditon为YES时程序继续运行，为NO时，则抛出带有desc描述的异常信息。NSAssert()可以出现在	  程序的任何一个位置。
	
### NSAssert和assert 区别
* NSAssert和assert都是断言,主要的差别是assert在断言失败的时候只是简单的终止程序,而NSAssert会报告出错误信息并且打印出来.所以只使用NSAssert就好,可以不去使用assert。

#### NSAssert/NSCAssert

* iOS中用的最多的是两对断言
	
	* NSAssert / NSParameterAssert
		
		定义 NSAssert
		
			#if !defined(_NSAssertBody)
		  	 #define NSAssert(condition, desc, ...)  \\\\
		    	do {              \\\\
			    	__PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \\\\
			   	 if (!(condition)) {       \\\\
			   	 [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd \\\\
			   	 object:self file:[NSString stringWithUTF8String:__FILE__] \\\\
			   	 lineNumber:__LINE__ description:(desc), ##__VA_ARGS__]; \\\\
			    	}             \\\\
		    	__PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \\\\
		   	 } while(0)
		    #endif
			    
		> 适用于 oc 方法
		
	* NSCAssert / NSCparameterAssert

		定义 NSCAssert
		
			#if !defined(_NSCAssertBody)
		    #define NSCAssert(condition, desc, ...) \\\\
		    	do {              \\\\
				    __PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \\\\
				    if (!(condition)) {       \\\\
				    [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \\\\
				    file:[NSString stringWithUTF8String:__FILE__] \\\\
				    lineNumber:__LINE__ description:(desc), ##__VA_ARGS__]; \\\\
				    }             \\\\
		    __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \\\\
		    } while(0)
			 #endif

		> 适用于 c 函数
	
	* NSAssert/NSCAssert 和 NSParameterAssert/NSCparameterAssert 的区别

		> 前者是针对条件断言, 后者只是针对参数是否存在的断言, 调试时候可以结合使用,先判断参数，再进一步断言，确认原因.
		
### NSAssert的用法
	int a = 1;
    NSCAssert(a == 2, @"a must equal to 2"); //第一个参数是条件,如果第一个参数不满足条件,就会记录并打印后面的字符串
    
运行则会崩溃并在控制台输出信息如下：

	*** Assertion failure in -[ViewController viewDidLoad],'/Users/guowenchao/Desktop/github_Top/OC-demo/NSAssert-demo/NSAssert-demo/ViewController.m:24'
	*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'a must equal to 2'

提示崩溃原因 **reason: 'a must equal to 2'**

崩溃的位置 **ViewController.m:24'**


### NSParameterAssert的用法
	- (void)assertWithPara:(NSString *)str
	{
	    NSParameterAssert(str); //只需要一个参数,如果参数存在程序继续运行,如果参数为空,则程序停止打印日志
	    //further code ...
	}
	
调用

	[self assertWithPara:@"succ"];
    NSLog(@"succ");
    [self assertWithPara:@""];
    NSLog(@"null");
    [self assertWithPara:nil];
    NSLog(@"nil");

输出
	
	2017-05-20 11:23:04.210908+0800 NSAssert-demo[1212:673294] succ
	2017-05-20 11:23:04.211043+0800 NSAssert-demo[1212:673294] null
	2017-05-20 11:23:04.211173+0800 NSAssert-demo[1212:673294] *** Assertion failure in -[ViewController assertWithPara:], /Users/guowenchao/Desktop/github_Top/OC-demo/NSAssert-demo/NSAssert-demo/ViewController.m:35
	2017-05-20 11:23:04.212393+0800 NSAssert-demo[1212:673294] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Invalid parameter not satisfying: str'
	*** First throw call stack:
	(0x1cf13b3d 0x1c19b067 0x1cf13a19 0x1d8094ed 0x892d3 0x89197 0x221422ff 0x22141f21 0x221484ab 0x22145a0b 0x221b5561 0x223b2f53 0x223b805d 0x223cac8d 0x223b579b 0x1e7f4c13 0x1e7f4acd 0x1e7f4db7 0x1cecffdd 0x1cecfb05 0x1cecdf51 0x1ce210ef 0x1ce20f11 0x221ab255 0x221a5e83 0x898cb 0x1c60e4eb)
	libc++abi.dylib: terminating with uncaught exception of type NSException
	
**Xcode 已经默认将release环境下的断言取消了, 免除了忘记关闭断言造成的程序不稳定. 所以不用担心 在开发时候大胆使用。**

![release下是不用担心的](/Users/guowenchao/Desktop/github_Top/OC-demo/NSAssert-demo/Enable_Founction_Assert.png)

### 自定义NSAssertionHandler

NSAssertionHandler实例是自动创建的，用于处理错误断言。如果 NSAssert和NSCAssert条件评估为错误，会向 NSAssertionHandler实例发送一个表示错误的字符串。每个线程都有它自己的NSAssertionHandler实例。
我们可以自定义处理方法，从而使用断言的时候，控制台输出错误，但是程序不会直接崩溃。