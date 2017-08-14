
### 什么是clang

clang可以将 C, C++, OC, OC++编译成LLVM代码。一旦编译为LLVM代码，就可以使用LLVM套件中的LLVM工具对程序进行分析了。

### 安装clang

#### 一、SVN 安装

##### 1. 安装前准备的工具

* 阅读[LLVM System](http://llvm.org/docs/GettingStarted.html#requirements)
* 安装[Python](http://www.python.org/download)
* 安装[CMake](http://www.cmake.org/download)
* 安装SVN（subversion）

> 以上三个都可以用 `brew` 安装, [brew的使用](https://github.com/wenchao8023/FFmpegGet/blob/master/mds/FFmpeg-install.md)

##### 2. [参考文档](http://clang.llvm.org/get_started.html)


#### 二 、git安装

* 1.下载llvm代码：

		git clone git@github.com:llvm-mirror/llvm.git

* 2.进入llvm/tools目录并下载clang代码

		cd llvm/tools
		git clone git@github.com:llvm-mirror/clang.git
		
* 3.进入llvm/projects目录并下载compiler-rt代码：

		cd ../projects
		git clone git@github.com:llvm-mirror/compiler-rt.git
		
* 4.在llvm所在目录新建与llvm同一级的目录build，并在其中构建llvm和clang

		cd ../..
		mkdir build
		cd mybuilddir
		cmake -G "Xcode" ../llvm