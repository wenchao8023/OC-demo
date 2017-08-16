# MacDown 语法

**【要注意符号和文本将的空格】**

## 六级标题

```
# H1
## H2
二级标题下面会自带一根分隔线
### H3
#### H4
##### H5
###### H6
六级标题颜色是灰色的
```


```
将内容前后用 ``` 包起来
```

## 列表

### 2.1 无序列表

* 1
* 2
* 3
* ...

### 2.2 有序列表

1. 1
2. 2
3. 3
4. ...

## 引用

> 使用尖括号（大于号）来引用一小段句子
> 
> 我是引用的第二行


## 图片与链接

插入图片和插入链接的语法很像，区别在一个！号

> * 图片为：![](){imgCap}{/ImgCap}
> 	
>   例如：![Mou icon](http://ww2.sinaimg.cn/large/6aee7dbbgw1efffa67voyj20ix0ctq3n.jpg)
> * 链接为：[百度](https://www.baidu.com)


## 粗体和斜体

Markdown 的粗体和斜体也非常简单，用两个 * 包含一段文本就是粗体的语法，用一个 * 包含一段文本就是斜体的语法。
例如：这里是**粗体** 这里是*斜体*


## 表格

表格是我觉得 Markdown 比较累人的地方，例子如下：

| 列 | 列 | 列 |  
| :--- | :---: | ----------: |
| 左对齐 | 居中对齐 | 右对齐 |
| aaaaaaaaaaaaa | bbbbbbbbbbbbbbbb | ccccccccccc |
最长的一排会自动背景加黑，然后都是居中对齐


## 代码框

*也可以对一些内容进行标记*

如果你是个程序猿，需要在文章里优雅的引用代码框，在 Markdown下实现也非常简单，只需要用两个 ` 把中间的代码包裹起来。图例：

iOS代码还是也用 ``` 来标记吧，因为第一排不太好表示

```
-(NSTimer *)udpTimer {

		if (!_udpTimer) {
        
	       dispatch_async(dispatch_get_global_queue(0, 0), ^{
	           
	            _udpTimer = [NSTimer timerWithTimeInterval:1.0                     // 每1s广播一次
	                                                target:self
	                                              selector:@selector(broadCastData)
	                                              userInfo:nil
	                                               repeats:YES];
	            
	            [[NSRunLoop currentRunLoop] addTimer:_udpTimer forMode:NSDefaultRunLoopMode];
	            
	            CFRunLoopRun();
	        });
	    }
	    
	    	return _udpTimer;
    }
    
``` 


`
-(NSTimer *)udpTimer {`

		if (!_udpTimer) {
        
	       dispatch_async(dispatch_get_global_queue(0, 0), ^{
	           
	            _udpTimer = [NSTimer timerWithTimeInterval:1.0                     // 每1s广播一次
	                                                target:self
	                                              selector:@selector(broadCastData)
	                                              userInfo:nil
	                                               repeats:YES];
	            
	            [[NSRunLoop currentRunLoop] addTimer:_udpTimer forMode:NSDefaultRunLoopMode];
	            
	            CFRunLoopRun();
	        });
	    }
	    
	    	return _udpTimer;
    }
   
使用 `tab` 键即可缩进。
    

## 分隔线

分割线的语法只需要三个 * 或 - 号，例如：

---
***

到这里，Markdown 的基本语法在日常的使用中基本就没什么大问题了，只要多加练习，配合好用的工具，写起东西来肯定会行云流水。更多的语法规则，其实 Mou 的 Help 文档栗子很好，当你第一次使用 Mou 时，就会显示该文档。可以用来对用的查找和学习。

***

---








