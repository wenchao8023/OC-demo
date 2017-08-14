//
//  twoViewController.m
//  runtime
//
//  Created by qianjianeng on 16/4/13.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "twoViewController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface twoViewController ()

@property (nonatomic, strong) Person *person;
@property (weak, nonatomic) IBOutlet UITextField *textview;

@end

@implementation twoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [Person new];
    
}

- (void)sayFrom
{
    //在 这个VC 中给 person 添加方法 guessAnswer 这个方法的实现
    
    //动态的给person添加了一个 guess 方法，然后方法的实现在 guessAnswer 方法中
    
    /**
     *  argu1 : class
     *  argu2 : 类本身并没有声明的方法
     *  argu3 : imp A function，至少要有 self 和 cmd 两个参数
     *  argu4 : type encode (见文档标签)
     */
    class_addMethod([self.person class], @selector(guess), (IMP)guessAnswer, "v@:");
    if ([self.person respondsToSelector:@selector(guess)]) {
        //Method method = class_getInstanceMethod([self.xiaoMing class], @selector(guess));
            [self.person performSelector:@selector(guess)];
        
    } else{
        NSLog(@"Sorry,I don't know");
    }
    self.textview.text = @"beijing";
}

void guessAnswer(id self,SEL _cmd){
    
    if ([self isKindOfClass:[Person class]])
    {
        //这里给 p 赋值之后，self.person也会有对应的值
        Person *p = self;
        p.name = @"chaoge";
        NSLog(@"%@ am from beijing", p.name);
    }
//    NSLog(@"i am from beijing");
    
}
- (IBAction)answer:(id)sender {
    
    [self sayFrom];
}



@end
