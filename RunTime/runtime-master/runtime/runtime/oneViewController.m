//
//  oneViewController.m
//  runtime
//
//  Created by qianjianeng on 16/4/13.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "oneViewController.h"
#import "Person.h"
#import <objc/runtime.h>
@interface oneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (nonatomic, strong) Person *person;
@end

@implementation oneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.person = [Person new];
    _person.name = @"xiaoming";
    NSLog(@"XiaoMing first answer is %@",self.person.name);
    
}


- (void)sayName
{
    unsigned int count = 0;
    //获取属性列表
    Ivar *ivar = class_copyIvarList([self.person class], &count);
    for (int i = 0; i<count; i++) {
        //获取属性 Ivar
        Ivar var = ivar[i];
        //将 Ivar 类型的属性 转成 c 字符串
        const char *varName = ivar_getName(var);
        //将 c 字符串 转成 oc 字符串
        NSString *proname = [NSString stringWithUTF8String:varName];
        
        if ([proname isEqualToString:@"_name"]) {   //这里别忘了给属性加下划线
            //设置属性
            //第一个参数 ：对象
            //第二个参数 ：对象的属性
            //第三个参数 ：要设置的值
            object_setIvar(self.person, var, @"daming");
            break;
        }
    }
    NSLog(@"XiaoMing change name  is %@",self.person.name);
    self.textfield.text = self.self.person.name;
}

- (IBAction)changename:(id)sender {
    [self sayName];
}

@end
