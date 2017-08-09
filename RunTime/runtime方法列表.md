### 一、基本概念

Runtime基本是用C和汇编写的，可见苹果为了动态系统的高效而作出的努力。你可以在[这里](http://opensource.apple.com//source/objc4/)下到苹果维护的开源代码。苹果和GNU各自维护一个开源的runtime版本，这两个版本之间都在努力的保持一致。Objective-C 从三种不同的层级上与 Runtime 系统进行交互，分别是通过 Objective-C 源代码，通过 Foundation 框架的NSObject类定义的方法，通过对 runtime 函数的直接调用。大部分情况下你就只管写你的Objc代码就行，runtime 系统自动在幕后辛勤劳作着。

* RunTime简称运行时,就是系统在运行的时候的一些机制，其中最主要的是消息机制。
* 对于C语言，函数的调用在编译的时候会决定调用哪个函数，编译完成之后直接顺序执行，无任何二义性。
* OC的函数调用成为消息发送。属于动态调用过程。在编译的时候并不能决定真正调用哪个函数（事实证明，在编 译阶段，OC可以调用任何函数，即使这个函数并未实现，只要申明过就不会报错。而C语言在编译阶段就会报错）。
* 只有在真正运行的时候才会根据函数的名称找 到对应的函数来调用

### 二、runtime的具体实现

我们写的oc代码，它在运行的时候也是转换成了runtime方式运行的，更好的理解runtime，也能帮我们更深的掌握oc语言。
每一个oc的方法，底层必然有一个与之对应的runtime方法。

* 当我们用OC写下这样一段代码
	
		[tableView cellForRowAtIndexPath:indexPath];

* 在编译时RunTime会将上述代码转化成[发送消息]

		objc_msgSend(tableView, @selector(cellForRowAtIndexPath:),indexPath);
		
### 三、常见方法

> 这里声明一个 count，可以用于后面的方法中需要存储值的

> `unsigned int count;`
		
* 获取属性列表(JsonKit中有使用)

	```
	objc_property_t *propertyList = class_copyPropertyList([self class], &count);
	 for (unsigned int i=0; i < count; i++)
	 {
	 	NSLog(@"%d -> %@",i, [NSString stringWithUTF8String:propertyName]);
	 }
	```

* 获取方法列表

	```
	 Method *methodList = class_copyMethodList([self class], &count);
	 for (unsigned int i=0; i < count; i++)
	 {
	 	NSLog(@"%d -> %@",i, NSStringFromSelector(method_getName(method)));
	 }
	```

* 获取成员变量列表

	```
	Ivar *ivarList = class_copyIvarList([self class], &count);
	 for (unsigned int i=0; i < count; i++)
	 {
	 	NSLog(@"%d -> %@",i, [NSString stringWithUTF8String:ivarName]);
	 }
	```

* 获取协议列表

	```
	__unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
	 for (unsigned int i=0; i < count; i++)
	 {
	 	NSLog(@"%d -> %@",i, [NSString stringWithUTF8String:protocolName]);
	 }
	```


> ```
> @interface Person : NSObject
>
> + (void) test1;
> 
> - (void) test2;
>
> @end
>
> ```
> 
> `Person xiaoming = [Person new]`

* 获得类方法
	
	```
	Class PersonClass = object_getClass([Person class]);
	SEL oriSEL = @selector(test1);
	Method oriMethod = class_getInstanceMethod(xiaomingClass, oriSEL);
	```

* 获得实例方法

	```
	Class PersonClass = object_getClass([xiaoming class]);
	SEL oriSEL = @selector(test2);
	Method cusMethod = class_getInstanceMethod(xiaomingClass, oriSEL);
	```

* 动态添加方法

	```
	BOOL addSucc = class_addMethod(xiaomingClass,
											 	 oriSEL, 
			   method_getImplementation(cusMethod), 
			   method_getTypeEncoding(cusMethod));
	```

* 替换原方法实现

	```
	class_replaceMethod(toolClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
	```

* 交换两个方法
	
	```
	method_exchangeImplementations(oriMethod, cusMethod);
	```

### 四、常见作用

* 动态的添加对象的成员变量和方法
* 动态交换两个方法的实现
* 拦截并替换方法
* 在方法上增加额外功能
* 实现NSCoding的自动归档和解档
* 实现字典转模型的自动转换

### 五、代码实现

#### 动态变量控制

> case ： xiaoming的age是10，后来被runtime变成了20

1. 动态获取XiaoMing类中的所有属性[包括私有]

		Ivar *ivar = class_copyIvarList([self.xiaoming class], &count);
		
2. 遍历属性找到对应name字段			

		const char *varName = ivar_getName(var);
		
3. 修改对应的字段值成20

		object_setIvar(self.xiaoMing, var, @"20");
		
4. 代码参考

		-(void)answer
		{
			 unsigned int count = 0;
			 Ivar *ivar = class_copyIvarList([self.xiaoMing class], &count);
			 for (int i = 0; i < count; i++)
			 {
			 		const char *ivarName = ivar[i];
					NSString *propertyName = [NSString stringWithUTF8String:ivarName];
					if ([propertyName isEqualToString:@"_name"])
					{
						object_setIvar(self.xiaoMing, var, @"20");
					}
			 }
	    }
	    
#### 动态添加方法

> case : 假设XiaoMing的中没有guess这个方法，后来被Runtime添加一个名字叫guess的方法，最终再调用guess方法做出相应。

1. 动态给XiaoMing类中添加guess方法

		 class_addMethod([self.xiaoMing class], @selector(guess), (IMP)guessAnswer, "v@:");
		 
2. 调用guess方法响应事件

		[self.xiaoMing performSelector:@selector(guess)]; 
		
	* **用来判断 xiaoming是否响应了这个方法，或者是这个方法是否添加成功。**
	* **也可以直接用 `1` 中的返回值来判断方法是否添加成功**
	
3. 编写guessAnswer的实现

		void guessAnswer(id self,SEL _cmd)
		{
			NSLog(@”i am from beijing”);
		}
		
	* **这里的方法是一个 C 方法，void 前面没有 + - 号**
	* **必须要有两个指定的参数(id self,SEL _cmd)**

4. 代码参考

		 -(void)answer
		 {
		     class_addMethod([self.xiaoMing class], @selector(guess), (IMP)guessAnswer, "v@:");
		     if ([self.xiaoMing respondsToSelector:@selector(guess)]) {
		
		         [self.xiaoMing performSelector:@selector(guess)];
		
		     } 
		     else
		     {
		         NSLog(@"Sorry,I don't know");
		     }
		 }
		
		 void guessAnswer(id self,SEL _cmd)
		 {
		     NSLog(@"i am from beijing");
		 }
		 
#### 这里给出两个用法作为示例，其他用法会在demo中给出解释


### 六、几个参数的概念

#### 1. objc_msgSend

官方文档 :

```
/* Basic Messaging Primitives
 *
 * On some architectures, use objc_msgSend_stret for some struct return types.
 * On some architectures, use objc_msgSend_fpret for some float return types.
 * On some architectures, use objc_msgSend_fp2ret for some float return types.
 *
 * These functions must be cast to an appropriate function pointer type 
 * before being called. 
 */
```

这是官方的声明，从这个函数的注释可以看出来了，这是个最基本的用于发送消息的函数。另外，这个函数并不能发送所有类型的消息，只能发送基本的消息。比如，在一些处理器上，我们必须

* 使用`objc_msgSend_stret`来发送返回值类型为结构体的消息
* 使用`objc_msgSend_fpret`来发送返回值类型为浮点类型的消息，
* 使用`objc_msgSend_fp2ret`来发送返回值类型为浮点类型的消息。

**最关键的一点：无论何时，要调用`objc_msgSend`函数，必须要将函数强制转换成合适的函数指针类型才能调用**

从`objc_msgSend`函数的声明来看，它应该是不带返回值的，但是我们在使用中却可以强制转换类型，以便接收返回值。另外，它的参数列表是可以任意多个的，前提也是要强制函数指针类型。

其实编译器会根据情况在`objc_msgSend`, `objc_msgSend_stret`, `objc_msgSendSuper`, 或 `objc_msgSendSuper_stret`四个方法中选择一个来调用。

* 如果消息是传递给超类，那么会调用名字带有”Super”的函数；
* 如果消息返回值是数据结构而不是简单值时，那么会调用名字带有”stret”的函数。

#### 2. id

objc_msgSend第一个参数类型为id，大家对它都不陌生，它是一个指向类实例的指针：

	`typedef struct objc_object *id;`
	
objc_object表示：

	struct objc_object { Class isa; };
	
objc_object结构体包含一个isa指针，根据isa指针就可以顺藤摸瓜找到对象所属的类。
PS:isa指针不总是指向实例对象所属的类，不能依靠它来确定类型，而是应该用class方法来确定实例对象的类。因为KVO的实现机理就是将被观察对象的isa指针指向一个中间类而不是真实的类，这是一种叫做 isa-swizzling 的技术，详见[官方文档](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOImplementation.html).


#### 3. SEL

`objc_msgSend`函数第二个参数类型为SEL，它是selector在Objc中的表示类型（Swift中是Selector类）。selector是方法选择器，可以理解为区分方法的 ID，而这个 ID 的数据结构是SEL:
	
	`typedef struct objc_selector *SEL;`
	
其实它就是个映射到方法的C字符串，你可以用 Objc 编译器命令@selector()或者 Runtime 系统的`sel_registerName`函数来获得一个SEL类型的方法选择器。

命名都遵循了公共前缀+类名+category名字的命名方式，不同类中相同名字的方法所对应的方法选择器是相同的，即使方法名字相同而变量类型不同也会导致它们具有相同的方法选择器，于是 Objc 中方法命名有时会带上参数类型(NSNumber一堆抽象工厂方法)

#### 4.Classs

之所以说isa是指针是因为Class其实是一个指向objc_class结构体的指针：

	typedef struct objc_class *Class;
	
objc_class详细信息：
		
		struct objc_class {
	    Class isa  OBJC_ISA_AVAILABILITY;
	#if  !__OBJC2__
	    Class super_class                                        OBJC2_UNAVAILABLE;
	    const char *name                                         OBJC2_UNAVAILABLE;
	    long version                                             OBJC2_UNAVAILABLE;
	    long info                                                OBJC2_UNAVAILABLE;
	    long instance_size                                       OBJC2_UNAVAILABLE;
	    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
	    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
	    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
	    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
	#endif
	
	} OBJC2_UNAVAILABLE;
	


可以看到运行时一个类还关联了它的超类指针，类名，成员变量，方法，缓存，还有附属的协议。

在objc_class结构体中：ivars是objc_ivar_list指针；methodLists是指向objc_method_list指针的指针。也就是说可以动态修改 *methodLists 的值来添加成员方法，这也是Category实现的原理.