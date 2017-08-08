//
//  NSString+String.h
//  Runtime4_动态添加属性
//
//  Created by chao on 2017/8/8.
//  Copyright © 2017年 wc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @property在分类里添加一个属性 不会有setter getter方法 只声明了一个变量 而且 这样声明 这个属性和这个类没有什么关系
 */
@interface NSString (String)

//@property (copy, nonatomic, nullable) NSString *name;

@property (copy, nonatomic, nullable) NSString *count;

@end
